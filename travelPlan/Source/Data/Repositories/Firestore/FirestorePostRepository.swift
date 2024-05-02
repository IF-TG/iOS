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

final class FirestorePostRepository {
  typealias Endpoint = FirestorePostAPIEndpoint
  
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  private let profileRepository: MyProfileRepository
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    firebaseStorageService: ImageStorageServiceProtocol,
    profileRepository: MyProfileRepository
  ) {
    self.service = service
    self.firebaseStorageService = firebaseStorageService
    self.profileRepository = profileRepository
  }
}

// MARK: - PostRepository
extension FirestorePostRepository: PostRepository {
  func fetchPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<PostsPage, any Error> {
    let isFirstPage = page == 1
    
    let endpoint = Endpoint.fetchPostsEndpoint()
    
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
        .sink { completion in
          if case .failure(let error) = completion {
            switch error as FirestoreServiceError {
            case .documentNotFound, .noMorePage:
              promise(.success(PostsPage(totalPosts: 0, posts: [], thumbnails: [], hasMorePage: false)))
            default:
              promise(.failure(error))
            }
          }
        } receiveValue: { responseDTO in
          let groupManager = DispatchGroup()
          /// 포스트는 순차적x. 빨리끝난것부터 반환. 그러기에 소팅해주어야합니다.
          var posts: [(post: Post, index: Int)] = []
          responseDTO.enumerated().forEach { index, postResponseDTO in
            var author: UserEntity?
            var postImages: [Post.PostImage] = []
            
            groupManager.enter()
            let group = DispatchGroup()
            group.enter()
            let profileSubscription = self.profileRepository.fetchProfile(with: postResponseDTO.authorId)
              .subscribe(on: DispatchQueue.global(qos: .userInteractive))
              .sink { completion in
                if case .failure(let error) = completion {
                  promise(.failure(error))
                  group.leave()
                }
              } receiveValue: { userEntity in
                author = userEntity
                group.leave()
              }
            self.subscriptions.insert(profileSubscription)
            
            group.enter()
            let imageSubscription = self.firebaseStorageService
              .fetchImages(postResponseDTO.postImageFiles.map { $0.url },
                           type: .postImage)
              .sink { completion in
                if case .failure(let error) = completion {
                  promise(.failure(error))
                  group.leave()
                }
              } receiveValue: { postImageDataList in
                print(postImageDataList, "이제 원래 있던 sort 추가해서 entity로 반환하면됨")
                postImages = postImageDataList
                  .enumerated()
                  .map { Post.PostImage(imageData: $1, sort: Int32(postResponseDTO.postImageFiles[$0].sort)) }
                group.leave()
              }
            self.subscriptions.insert(imageSubscription)
            
            group.notify(queue: DispatchQueue.global(qos: .userInteractive)) { [index] in
              let post = responseDTO[index].toDomain(
                liked: nil,
                authorImageData: author?.profileImageData,
                authorName: author?.nickname ?? "여행자",
                postImages: postImages)
              posts.append((post, index))
            }
          }
          groupManager.notify(queue: DispatchQueue.global(qos: .userInteractive)) {
            let postsPage = PostsPage(
              totalPosts: Int64.max,
              posts: posts.sorted(by: { $0.index < $1.index }).map { $0.post },
              thumbnails: [])
            promise(.success(postsPage))
          }
        }
      subscriptions.insert(serviceSubscription)
    }.eraseToAnyPublisher()
  }
  
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
}

// MARK: - PostRepository
extension FirestorePostRepository {
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: String
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    fatalError("미 구현")
  }
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    fatalError("미 구현")
  }
  
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    fatalError("미 구현")
  }
}
