//
//  FirestorePostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation
import SHFirestoreService
import FirebaseFirestore
import Combine
import os.log

final class FirestorePostRepository {
  typealias Endpoint = FirestorePostAPIEndpoint
  typealias IndexedAtomicPost = (index: Int, post: AtomicPost)
  
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  private let ownerStorage: OwnerStorage
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    firebaseStorageService: ImageStorageServiceProtocol,
    ownerStorage: OwnerStorage,
    backgroundQueue: DispatchQueue = .global(qos: .default)
  ) {
    self.service = service
    self.firebaseStorageService = firebaseStorageService
    self.backgroundQueue = backgroundQueue
    self.ownerStorage = ownerStorage
  }
}

// MARK: - PostRepository
/// 페이징 실패할 경우 Common에서 정의한 PaginationError를 방출합니다.
extension FirestorePostRepository: PostFetchAtomicRepository {
  func fetchFilteredPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<[AtomicPost], any Error> {
    let isFirstPage = page == 1
    let endpoint = Endpoint.makePostsFetchEndpoint()
    
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let serviceSubscription = service.paginate(
        endpoint: endpoint,
        makeQuery: { ref in
          let query = self.makeBaseQuery(
            ref,
            perPage: perPage,
            withOrderBy: category.orderBy)
          self.appendMainThemeCategoryQuery(
            query,
            withMainTheme: category.mainTheme)
          return query
        },
        isFirstPagination: isFirstPage)
        .eraseToError()
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] responseDTO in
          self?.handlePostsFetch(from: responseDTO, to: promise)
        }
      subscriptions.insert(serviceSubscription)
    }.eraseToAnyPublisher()
  }
  
  /// 로그인한 사용자가 하트한 포스트들을 페이징으로 불러오는 함수입니다.
  ///
  /// Note:
  /// 1. page는 1페이지부터 시작합니다.
  ///
  /// 2. 여기서는 SHFIrestoreService의 paginate 함수를 사용하지 않습니다.
  ///   - Firestore's Query의 whereField에서 배열 검사는 최대 30개까지 지원하기 때문입니다.
  ///   - users 컬랙션에 owner 문서의 post-hearts에서 좋아했던 포스트 uid list 는 30개를 훌쩍 넘을수있기 때문입니다.
  func fetchOwnerLikedPosts(
    page: Int32,
    perPage: Int32 = 10,
    likedPostIdList: [PostIdentifier]
  ) -> AnyPublisher<[AtomicPost], any Error> {
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(PostFetchAtomicRepositoryError.invalidSelfReference))
        return
      }
      let startPageIndex = Int((page-1)*perPage)
      var endPageIndex = Int((page)*perPage)
      if endPageIndex > likedPostIdList.count {
        if startPageIndex > likedPostIdList.count {
          promise(.failure(PaginationError.noMorePage))
          return
        } else {
          endPageIndex = likedPostIdList.count
        }
      }
      
      let endpoints = makeSpecificPostFetchEndpoints(likedPostIdList, from: startPageIndex, to: endPageIndex)
      
      let requests = Publishers.Sequence(sequence: endpoints)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .flatMap { [weak self] endpoint -> AnyPublisher<FirestorePostResponseDTO, any Error> in
          guard let self else {
            return Fail(error: PostFetchAtomicRepositoryError.invalidSelfReference).eraseToAnyPublisher()
          }
          return service.request(endpoint: endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        }
        .collect(endpoints.count)
        .eraseToAnyPublisher()
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(PostFetchAtomicRepositoryError.serviceError(error)))
          }
        } receiveValue: { [weak self] postResponsesDTO in
          self?.handlePostsFetch(from: postResponsesDTO, to: promise)
        }
      subscriptions.insert(requests)
    }.eraseToAnyPublisher()
  }
  
  func fetchOwnerWrotePosts(
    isFirstPage: Bool,
    perPage: Int32 = 10
  ) -> AnyPublisher<[AtomicPost], any Error> {
    let endpoint = Endpoint.makePostsFetchEndpoint()
    guard let ownerId = ownerStorage.id else {
      return Fail(error: PostFetchAtomicRepositoryError.invalidOwnerId).eraseToAnyPublisher()
    }
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(PostFetchAtomicRepositoryError.invalidSelfReference))
        return
      }
      let paginate = service
        .paginate(
          endpoint: endpoint,
          makeQuery: { collectionRef in
            return collectionRef
              .whereField("authorId", isEqualTo: ownerId)
              .limit(to: Int(perPage))
          },
          isFirstPagination: isFirstPage)
        .subscribeAndReceive(on: backgroundQueue)
        .eraseToError()
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] postResponsesDTO in
          self?.handlePostsFetch(from: postResponsesDTO, to: promise)
        }
      subscriptions.insert(paginate)
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension FirestorePostRepository {
  /// 둘 중 하나의 정렬은 반드시 들어갑니다.
  private func makeBaseQuery(
    _ ref: CollectionReference,
    perPage: Int32,
    withOrderBy orderBy: TravelOrderType
  ) -> Query {
    let query = ref.order(by: "createAt", descending: true)
      .limit(to: Int(perPage))
    if case .popularity = orderBy {
      return query.order(by: "likeNum", descending: true)
    }
    return query
  }
  
  private func appendMainThemeCategoryQuery(
    _ query: Query,
    withMainTheme main: TravelMainThemeType
  ) {
    /// all, cateogryDevelop의 경우 부수적인 qeury가 없습니다.
    guard let mainThemeField = TravelMainThemeTypeMapper.toFirestoreField(main) else { return }
    switch main {
    case .all,
         .categoryDevelop:
      break
    case .season(let season):
      if let seasion = season {
        query.whereField(mainThemeField, arrayContains: SeasonMapper.toDTO(seasion))
      } else {
        query.whereField(mainThemeField, isGreaterThan: [])
      }
    case .region(let travelRegion):
      if let travelRegion {
        query.whereField(mainThemeField, arrayContains: TravelRegionMapper.toDTO(travelRegion))
      } else {
        query.whereField(mainThemeField, isGreaterThan: [])
      }
    case .travelTheme(let travelTheme):
      if let travelTheme {
        query.whereField(mainThemeField, arrayContains: TravelThemeMapper.toDTO(travelTheme))
      } else {
        query.whereField(mainThemeField, isGreaterThan: [])
      }
    case .partner(let travelPartner):
      if let travelPartner {
        query.whereField(mainThemeField, arrayContains: TravelPartnerMapper.toDTO(travelPartner))
      } else {
        query.whereField(mainThemeField, isGreaterThan: [])
      }
    }
  }
  
  /// Dispatch그룹으로 받을 경우 포스트는 순차적으로 받지 않기에. 빨리끝난것부터 반환. 그래서 소팅 해주어야 합니다.
  private func handlePostsFetch(
    from responseDTO: [FirestorePostResponseDTO],
    to promise: @escaping Future<[AtomicPost], any Error>.Promise
  ) {
    let groupManager = DispatchGroup()
    var posts: [IndexedAtomicPost] = []
    for (index, postResponseDTO) in responseDTO.enumerated() {
      var postImages: [Post.PostImage] = []
      let group = DispatchGroup()
      groupManager.enter()
      group.enter()
      let imageSubscription = firebaseStorageService
        .fetchImages(postResponseDTO.postImageFiles.map { $0.url }, type: .postImage)
        .sink { [weak self] completion in
          if case .failure(let error) = completion {
            self?.logImageFetchError(postId: postResponseDTO.postId, error: error)
            group.leave()
          }
        } receiveValue: { postImageDataList in
          postImages = postImageDataList
            .enumerated()
            .map { Post.PostImage(imageData: $1, sort: Int32(postResponseDTO.postImageFiles[$0].sort)) }
          group.leave()
        }
      subscriptions.insert(imageSubscription)
      group.notify(queue: backgroundQueue) { [index] in
        /// 포스트 받아올때 이상이 있을 경우 해당 포스트는 제외합니다.
        guard postImages.count > 0 else {
          groupManager.leave()
          return
        }
        let post = responseDTO[index].toDomain(postImages: postImages)
        posts.append((index, post))
        groupManager.leave()
      }
    }
    groupManager.notify(queue: backgroundQueue) {
      promise(.success(posts.sorted(by: { $0.index < $1.index }).map { $0.post }))
    }
  }
}

// MARK: - Private Helpers
extension FirestorePostRepository {
  func makeSpecificPostFetchEndpoints(
    _ postIdList: [PostIdentifier],
    from: Int,
    to: Int
  ) -> [FirestoreEndpoint<FirestorePostResponseDTO>] {
    return postIdList[from..<to].map { Endpoint.makeSpecificPostFetchEndpoint(postId: $0) }
  }
  
  func logImageFetchError(postId: String, error: any Error) {
    os_log(
      "Error occured when fetching post's images. postId: %@, error:%@",
      log: .default,
      type: .error,
      postId, error.localizedDescription)
  }
}
