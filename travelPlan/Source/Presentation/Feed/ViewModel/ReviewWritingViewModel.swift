//
//  ReviewWritingViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 11/12/23.
//

import Foundation
import Combine
import Photos

protocol ReviewWritingViewModel: ViewModelable
where Input == ReviewWritingViewModelInput,
      State == ReviewWritingViewModelState,
      Output == AnyPublisher<State, Never> { }

struct ReviewWritingViewModelInput {
  let didTapTitleTextView: PassthroughSubject<Void, Never> = .init()
  let didTapCancelButton: PassthroughSubject<Void, Never> = .init()
  let didTapKeyboardDownButton: PassthroughSubject<Void, Never> = .init()
  let didTapFinishButton: PassthroughSubject<([PostContentEntity], String), Never> = .init()
  let didTapAlbumButton: PassthroughSubject<Void, Never> = .init()
  let didTapPlanView: PassthroughSubject<Void, Never> = .init()
  let didTapNavigationTitleView: PassthroughSubject<Void, Never> = .init()
  let didTapView: PassthroughSubject<Void, Never> = .init()
  let didTapScrollView: PassthroughSubject<Void, Never> = .init()
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
}

enum ReviewWritingMode {
  case new
  case edit(ReviewWritingEntity)
}

enum ReviewWritingViewModelState {
  case unexpectedError(description: String)
  case popViewControllerWith(Post?)
  case popViewController
  case presentAlbumViewController
  case presentPlan
  case keyboardDown
  case manageTextViewDisplay
  case presentThemeSetting
  case none
  case alertAuthRequest
  case setupContents(title: String, contents: [PostContentEntity])
}

final class DefaultReviewWritingViewModel: ReviewWritingViewModel {
  
  // MARK: - Dependencies
  private let photoAuthorizationUseCase: any PhotoAuthorizationUseCase
  private let reviewWritingUseCase: any ReviewWritingUseCase
  private let loggedInOwnerUseCase: any LoggedInUserUseCase
  private let mode: ReviewWritingMode
  private var reviewWritingEntity: ReviewWritingEntity?
  
  // MARK: - LifeCycle
  init(
    photoAuthorizationUseCase: any PhotoAuthorizationUseCase,
    reviewWritingUseCase: any ReviewWritingUseCase,
    loggedInOwnerUseCase: any LoggedInUserUseCase,
    mode: ReviewWritingMode
  ) {
    self.photoAuthorizationUseCase = photoAuthorizationUseCase
    self.reviewWritingUseCase = reviewWritingUseCase
    self.loggedInOwnerUseCase = loggedInOwnerUseCase
    self.mode = mode
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - Helpers
extension DefaultReviewWritingViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany(
        viewDidLoadStream(input),
        didTapCancelButtonStream(input),
        didTapKeyboardDownButtonStream(input),
        didTapViewStream(input),
        didTapPlanViewStream(input),
        didTapScrollViewStream(input),
        didTapNavigationTextViewStream(input),
        didTapFinishButtonStream(input),
        didTapAlbumButtonStream(input)
      )
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultReviewWritingViewModel {
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
  
  private func didTapCancelButtonStream(_ input: Input) -> Output {
    return input.didTapCancelButton
      .map { State.popViewController }
      .eraseToAnyPublisher()
  }
  
  private func didTapKeyboardDownButtonStream(_ input: Input) -> Output {
    return input.didTapKeyboardDownButton
      .map { State.keyboardDown }
      .eraseToAnyPublisher()
  }
  
  private func didTapViewStream(_ input: Input) -> Output {
    return input.didTapView
      .map { State.keyboardDown }
      .eraseToAnyPublisher()
  }
  
  private func didTapPlanViewStream(_ input: Input) -> Output {
    return input.didTapPlanView
      .map { State.presentPlan }
      .eraseToAnyPublisher()
  }
  
  private func didTapScrollViewStream(_ input: Input) -> Output {
    return input.didTapScrollView
      .map { State.manageTextViewDisplay }
      .eraseToAnyPublisher()
  }
  
  private func didTapNavigationTextViewStream(_ input: Input) -> Output {
    return input.didTapNavigationTitleView
      .map { State.presentThemeSetting }
      .eraseToAnyPublisher()
  }
  
  private func didTapAlbumButtonStream(_ input: Input) -> Output {
    return input.didTapAlbumButton
      .flatMap { [weak self] in
        guard let self else { return Just(State.none).eraseToAnyPublisher() }
        
        return self.photoAuthorizationUseCase.requestAuthorization()
          .receive(on: RunLoop.main)
          .map { status in
            switch status {
            case .authorized, .limited:
              return State.presentAlbumViewController
            case .denied, .restricted, .notDetermined:
              return State.alertAuthRequest
            @unknown default:
              print("DEBUG: Apple API에서 새로운 타입을 추가했기때문에 새 타입에 대한 대응을 구현해야합니다.")
              return State.none
            }
          }
          .eraseToAnyPublisher()
      }
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
          let tempThemeEntity = ReviewWritingEntity(
            postId: UUID().uuidString,
            category: .init(themes: [.adventure],
                            regions: [.busan],
                            seasons: [.fall],
                            partners: [.alone]),
            // TODO: - yyyy.MM.dd형식으로 Date를 반환해야합니다.
            tripDate: .init(
              startDate: DateTimeConverter.toDate(from: "2023.10.24")! ,
              endDate: DateTimeConverter.toDate(from: "2023.10.27")!),
            title: title,
            contents: contents,
            authorId: self?.loggedInOwnerUseCase.id
          )
          return reviewWritingUseCase.savePost(entity: tempThemeEntity)
            .filter { $0 }
            .map { _ in State.popViewController }
            .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
        case .edit:
          guard let entity = self?.reviewWritingEntity
          else { return Just(State.none).eraseToAnyPublisher() }
          
          return reviewWritingUseCase.updatePost(requestValue: .init(entity: entity, postId: entity.postId))
            .map { post -> State in
              if let post {
                return State.popViewControllerWith(post)
              } else {
                return State.popViewControllerWith(nil)
              }
            }
            .catch { Just(State.unexpectedError(description: $0.localizedDescription)).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
}
