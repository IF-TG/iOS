//
//  DefaultReviewWritingViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 11/12/23.
//

import Foundation
import Combine
import Photos

struct ReviewWritingViewModelInput {
  let didTapTitleTextView: PassthroughSubject<Void, Never> = .init()
  let didTapFinishButton: PassthroughSubject<([PostContentEntity], String), Never> = .init()
  let didTapScrollView: PassthroughSubject<Void, Never> = .init()
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
}

enum ReviewWritingMode {
  case new
  case edit(ReviewWritingEntity)
}

struct ReviewWritingViewModelActions {
  let showAlbum: () -> Void
  let showCategoryBottomSheet: () -> Void
  let pop: () -> Void
  let popWith: (Post?) -> Void
  let presentPlan: () -> Void
  let alertAuthRequest: () -> Void
}

enum ReviewWritingViewModelState {
  case unexpectedError(description: String)
  case savedReviewWritingSuccessfully
  case savedReviewWritingEditSuccessfully(post: Post?)
  case configureImage(sortedDatas: [Data?])
  case manageTextViewDisplay
  case none
  case setupContents(title: String, contents: [PostContentEntity])
}

final class DefaultReviewWritingViewModel {
  // MARK: - Dependencies
  private let reviewWritingUseCase: any ReviewWritingUseCase
  private let loggedInOwnerUseCase: any LoggedInUserUseCase
  private let mode: ReviewWritingMode
  private let actions: ReviewWritingViewModelActions
  
  private let selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>
  
  // MARK: - Properties
  private var reviewWritingEntity: ReviewWritingEntity?
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(
    reviewWritingUseCase: any ReviewWritingUseCase,
    loggedInOwnerUseCase: any LoggedInUserUseCase,
    mode: ReviewWritingMode,
    actions: ReviewWritingViewModelActions,
    selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>
  ) {
    self.reviewWritingUseCase = reviewWritingUseCase
    self.loggedInOwnerUseCase = loggedInOwnerUseCase
    self.mode = mode
    self.actions = actions
    self.selectedAssetsPublisher = selectedAssetsPublisher
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - ReviewWritingViewModelable
extension DefaultReviewWritingViewModel: ReviewWritingViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany(
        viewDidLoadStream(input),
        didTapScrollViewStream(input),
        didTapFinishButtonStream(input),
        selectedAssetsStream()
      )
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultReviewWritingViewModel {
  private func selectedAssetsStream() -> Output {
    selectedAssetsPublisher.flatMap { assets in
      let group = DispatchGroup()
      var datas = [(index: Int, data: Data?)]()
      
      for (index, asset) in assets.enumerated() {
        group.enter()
        let photoService = DefaultPhotoService()
        photoService.fetchImageData(
          asset: asset,
          size: PHImageManagerMaximumSize,
          contentMode: .aspectFill,
          resizeModeOption: .none) { data in
            datas.append((index: index, data: data))
            group.leave()
          }
      }
      
      return Future<ReviewWritingViewModelState, Never> { promise in
        group.notify(queue: .main) {
          let sortedDatas = datas.sorted { $0.0 < $1.0 }.map { $0.1 }
          promise(.success(State.configureImage(sortedDatas: sortedDatas)))
        }
      }
      .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] in
        if case let .edit(entity) = self?.mode {
          self?.reviewWritingEntity = entity
          return State.setupContents(title: entity.title, contents: entity.contents)
        }
        return State.none
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapScrollViewStream(_ input: Input) -> Output {
    return input.didTapScrollView
      .map { State.manageTextViewDisplay }
      .eraseToAnyPublisher()
  }
  
  private func didTapFinishButtonStream(_ input: Input) -> Output {
    return input.didTapFinishButton
      .flatMap { [weak self, reviewWritingUseCase, mode] contents, title in
        self?.reviewWritingEntity?.contents = contents
        self?.reviewWritingEntity?.title = title
        
        switch mode {
        case .new:
          // TODO: - 사용자가 정의한 테마 설정을 기반으로 eneity를 정의해야합니다.
          
          // MARK: About postId.
          // postId를 생성한 이유는 Firestore를 사용할 때 postId를 직접 지정하기 위해서 입니다.
          // 지정할 때 identifiable한 알고리즘을 사용해야합니다.
          // 지금은 spring server을 사용하므로 -1을 넣습니다.
          let tempThemeEntity = ReviewWritingEntity(
            postId: -1,
            category: .init(themes: [.adventure],
                            regions: [.busan],
                            seasons: [.fall],
                            partners: [.alone]),
            // MARK: yyyy.MM.dd형식으로 Date를 반환해야합니다.
            tripDate: .init(
              startDate: DateTimeConverter.toDate(from: "2023.10.24")!,
              endDate: DateTimeConverter.toDate(from: "2023.10.27")!),
            title: title,
            contents: contents,
            authorId: self?.loggedInOwnerUseCase.id
          )
          return reviewWritingUseCase.savePost(entity: tempThemeEntity)
            .filter { $0 }
            .map { _ in State.savedReviewWritingSuccessfully }
            .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
        case .edit:
          guard let entity = self?.reviewWritingEntity
          else { return Just(State.none).eraseToAnyPublisher() }
          
          return reviewWritingUseCase.updatePost(requestValue: .init(entity: entity, postId: entity.postId))
            .map { post -> State in
              if let post {
                return State.savedReviewWritingEditSuccessfully(post: post)
              } else {
                return State.savedReviewWritingEditSuccessfully(post: nil)
              }
            }
            .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - ReviewWritingViewModelPageDelegate
extension DefaultReviewWritingViewModel: ReviewWritingViewModelPageDelegate {
  func pop() {
    actions.pop()
  }
  
  func didTapAlbumButton() {
    reviewWritingUseCase.requestAuthorization()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (status: PHAuthorizationStatus) in
        switch status {
        case .authorized, .limited:
          self?.actions.showAlbum()
        case .denied, .restricted, .notDetermined:
          self?.actions.alertAuthRequest()
        @unknown default:
          print("DEBUG: Apple API에서 새로운 타입을 추가했기때문에 새 타입에 대한 대응을 구현해야합니다.")
        }
      }
      .store(in: &subscriptions)
  }
  
  func pop(with post: Post?) {
    actions.popWith(post)
  }
  
  func presentPlan() {
    actions.presentPlan()
  }
  
  func showCategoryBottomSheet() {
    actions.showCategoryBottomSheet()
  }
}
