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
  let didTapFinishButton: PassthroughSubject<(ReviewWritingContentViewInfo), Never> = .init()
  let didTapScrollView: PassthroughSubject<Void, Never> = .init()
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  /// 사진과 텍스트 모두 추가되었는지 검증하는 Publisher입니다.
  let validatePhotoAndTextAreAdded: PassthroughSubject<Bool, Never> = .init()
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
  case activateFinishButton(Bool)
}

final class DefaultReviewWritingViewModel {
  // MARK: - Dependencies
  private let reviewWritingUseCase: any ReviewWritingUseCase
  private let loggedInOwnerUseCase: any LoggedInUserUseCase
  private let mode: ReviewWritingMode
  private let actions: ReviewWritingViewModelActions
  
  private let selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>
  /// 바텀시트의 완료버튼이 눌리거나 dismiss될 때 사용됩니다.
  private let selectedCategoryPublisher: AnyPublisher<Post.Category?, Never>
  
  // MARK: - Properties
  private var reviewWritingEntity: ReviewWritingEntity?
  private var subscriptions = Set<AnyCancellable>()
  private var category: Post.Category?
  private var arePhotoAndTextAdded: Bool?
  private let finishButtonStatePublisher = PassthroughSubject<Void, Never>()
  
  // MARK: - LifeCycle
  init(
    reviewWritingUseCase: any ReviewWritingUseCase,
    loggedInOwnerUseCase: any LoggedInUserUseCase,
    mode: ReviewWritingMode,
    actions: ReviewWritingViewModelActions,
    selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>,
    selectedCategoryPublisher: AnyPublisher<Post.Category?, Never>
  ) {
    self.reviewWritingUseCase = reviewWritingUseCase
    self.loggedInOwnerUseCase = loggedInOwnerUseCase
    self.mode = mode
    self.actions = actions
    self.selectedAssetsPublisher = selectedAssetsPublisher
    self.selectedCategoryPublisher = selectedCategoryPublisher
    
    bind()
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
        selectedAssetsStream(),
        validatePhotoAndTextAreAddedStream(input),
        finishButtonStateStream()
      )
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultReviewWritingViewModel {
  private func bind() {
    selectedCategoryPublisher.sink { [weak self] category in
      self?.category = category
      self?.finishButtonStatePublisher.send()
    }.store(in: &subscriptions)
  }
  
  private func finishButtonStateStream() -> Output {
    return finishButtonStatePublisher
      .map { [weak self] _ in
        guard let arePhotoAndTextAdded = self?.arePhotoAndTextAdded else { return State.none }
        if self?.category != nil, arePhotoAndTextAdded {
          return State.activateFinishButton(true)
        } else {
          return State.activateFinishButton(false)
        }
      }
      .eraseToAnyPublisher()
  }
  
  private func validatePhotoAndTextAreAddedStream(_ input: Input) -> Output {
    // photo text O, 카테고리 X -> X
    // photo text X, 카테고리 X -> X
    // photo text X, 카테고리 O -> X
    // photo text O, 카테고리 O -> O
    
    
    // edit모드인 경우에는 기본적으로 카테고리가 지정되어 있음.
    // 이때 바텀시트를 초기화하면 카테고리가 지워짐
    
    // new모드인 경우에는 기본적으로 카테고리가 지정되어 있지 않음.
    
    return input.validatePhotoAndTextAreAdded
      .map { [weak self] isAdded in
        self?.arePhotoAndTextAdded = isAdded
        
        if isAdded, self?.category != nil {
          return State.activateFinishButton(true)
        } else {
          return State.activateFinishButton(false)
        }
      }
      .eraseToAnyPublisher()
  }
  
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
    // edit의 경우에는 mode의 연관값에 category가 들어있지만, 추후 초기화 가능성을 고려해서 private let category를 사용하는것이 나을듯
    // 즉, bind를 통해 self.category값이 지정되므로 self.category를 사용하면 된다.
    // 초기화 버튼을 누를 경우에는 self.category를 nil로 변환해준다. 이때 리뷰작성 완료버튼을 비활성화 해주어야 한다.
      .flatMap { [weak self, reviewWritingUseCase, mode] contentInfo in
        guard let category = self?.category else { return Just(State.none).eraseToAnyPublisher() }
        
        self?.reviewWritingEntity?.contents = contentInfo.contents
        self?.reviewWritingEntity?.title = contentInfo.title
        switch mode {
        case .new:
          print("카테고리: \(category)")
          
          // MARK: About postId.
          // postId를 생성한 이유는 Firestore를 사용할 때 postId를 직접 지정하기 위해서 입니다.
          // 지정할 때 identifiable한 알고리즘을 사용해야합니다.
          // 지금은 spring server을 사용하므로 -1을 넣습니다.
          
          // TODO: - Date UI가 반영되면 temp를 제거합니다.
          let tempDate = Post.TripDate(
            startDate: DateTimeConverter.toDate(from: "2023.10.24")!,
            endDate: DateTimeConverter.toDate(from: "2023.10.27")!)
          
          let reviewWritingEntity = ReviewWritingEntity(
            postId: -1,
            category: .init(
              themes: category.themes,
              regions: category.regions,
              seasons: category.seasons,
              partners: category.partners
            ),
            tripDate: tempDate,
            title: contentInfo.title,
            contents: contentInfo.contents,
            authorId: self?.loggedInOwnerUseCase.id
          )
          return reviewWritingUseCase.savePost(entity: reviewWritingEntity)
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
