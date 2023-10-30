//
//  LoginViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

final class LoginViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  struct Input {
    let viewWillAppear: PassthroughSubject<Void, Never>
    let viewDidLoad: PassthroughSubject<Void, Never>
    let didTapKakaoButton: PassthroughSubject<Void, ErrorType>
    let didTapAppleButton: PassthroughSubject<Void, ErrorType>
    let didTapGoogleButton: PassthroughSubject<Void, ErrorType>
    
    init(viewWillAppear: PassthroughSubject<Void, Never> = .init(),
         viewDidLoad: PassthroughSubject<Void, Never> = .init(),
         didTapKakaoButton: PassthroughSubject<Void, ErrorType> = .init(),
         didTapAppleButton: PassthroughSubject<Void, ErrorType> = .init(),
         didTapGoogleButton: PassthroughSubject<Void, ErrorType> = .init()) {
      self.viewWillAppear = viewWillAppear
      self.viewDidLoad = viewDidLoad
      self.didTapKakaoButton = didTapKakaoButton
      self.didTapAppleButton = didTapAppleButton
      self.didTapGoogleButton = didTapGoogleButton
    }
  }
  enum ErrorType: Error {
    case none
    case unexpectedError
  }
  enum State {
    case appear
    case viewLoad
    case none
    case presentKakao
    case presentApple
    case presentGoogle
  }
  // MARK: - Properties
}

// MARK: - ViewModelCase
extension LoginViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany([
        viewWillAppearStream(input),
        viewDidLoadStream(input),
        didTapKakaoButtonStream(input),
        didTapAppleButtonStream(input),
        didTapGoogleButtonStream(input)
      ])
      .eraseToAnyPublisher()
  }
}

// MARK: - Input operator chain Flow
private extension LoginViewModel {
  private func didTapKakaoButtonStream(_ input: Input) -> Output {
    return input
      .didTapKakaoButton
      .tryMap { [weak self] _ in
        // TODO: - Kakako 로그인 화면 구현하기
        return State.presentKakao
      }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  private func didTapAppleButtonStream(_ input: Input) -> Output {
    return input
      .didTapAppleButton
      .tryMap { [weak self] _ in
        // TODO: - Apple 로그인 화면 구현하기
        return State.presentApple
      }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  private func didTapGoogleButtonStream(_ input: Input) -> Output {
    return input
      .didTapGoogleButton
      .tryMap { [weak self] _ in
        // TODO: - Google 로그인 화면 구현하기
        return State.presentGoogle
      }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  private func viewWillAppearStream(_ input: Input) -> Output {
    return input
      .viewWillAppear
      .tryMap { return .appear }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  private func viewDidLoadStream(_ input: Input) -> Output {
    return input
      .viewDidLoad
      .tryMap { return .viewLoad }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
}
