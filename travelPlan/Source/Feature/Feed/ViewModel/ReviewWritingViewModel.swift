//
//  ReviewWritingViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 11/12/23.
//

import Foundation
import Combine

final class ReviewWritingViewModel {
  typealias Output = AnyPublisher<State, Never>
  
  struct Input {
    let didTapTitleTextView: PassthroughSubject<Void, Never> = .init()
    let didTapCancelButton: PassthroughSubject<Void, Never> = .init()
    let didTapKeyboardDownButton: PassthroughSubject<Void, Never> = .init()
    let didTapFinishButton: PassthroughSubject<Void, Never> = .init() // 작성 내용을 vm으로 전달
    let didTapAlbumButton: PassthroughSubject<Void, Never> = .init()
    let didTapPlanView: PassthroughSubject<Void, Never> = .init()
    let didTapNavigationTitleView: PassthroughSubject<Void, Never> = .init()
    let didTapView: PassthroughSubject<Void, Never> = .init()
    let didTapScrollView: PassthroughSubject<Void, Never> = .init()
  }
  
  enum State {
    case popViewController
    case presentAlbumViewController
    case presentPlan
    case keyboardDown
    case manageTextViewDisplay
    case presentThemeSetting
  }
}

// MARK: - Helpers
extension ReviewWritingViewModel {
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
      .map { State.presentAlbumViewController }
      .eraseToAnyPublisher()
  }
  
  private func didTapFinishButtonStream(_ input: Input) -> Output {
    return input.didTapFinishButton
      .map {
        // TODO: - content를 서버에 저장합니다.
        return State.popViewController
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension ReviewWritingViewModel {
  
}
