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
  let didTapFinishButton: PassthroughSubject<[PostDetailContentType2], Never> = .init()
  let didTapAlbumButton: PassthroughSubject<Void, Never> = .init()
  let didTapPlanView: PassthroughSubject<Void, Never> = .init()
  let didTapNavigationTitleView: PassthroughSubject<Void, Never> = .init()
  let didTapView: PassthroughSubject<Void, Never> = .init()
  let didTapScrollView: PassthroughSubject<Void, Never> = .init()
}

enum ReviewWritingViewModelState {
  case popViewController
  case presentAlbumViewController
  case presentPlan
  case keyboardDown
  case manageTextViewDisplay
  case presentThemeSetting
  case none
  case alertAuthRequest
}

final class DefaultReviewWritingViewModel: ReviewWritingViewModel {

  // MARK: - Properties
  private let photoAuthorizationUseCase: PhotoAuthorizationUseCase
  private let reviewWritingUseCase: ReviewWritingUseCase
  
  // MARK: - LifeCycle
  init(
    photoAuthorizationUseCase: PhotoAuthorizationUseCase,
    reviewWritingUseCase: ReviewWritingUseCase
  ) {
    self.photoAuthorizationUseCase = photoAuthorizationUseCase
    self.reviewWritingUseCase = reviewWritingUseCase
  }
}

// MARK: - Helpers
extension DefaultReviewWritingViewModel {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany(
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
      .map { [weak self] contentData in
        // TODO: - contentData를 서버에 저장해야 합니다.
        print("contentData: \(contentData)")
        return State.popViewController
      }
      .eraseToAnyPublisher()
  }
}
