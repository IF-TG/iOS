//
//  LoginViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

final class LoginViewModel {
  // MARK: - Properties
}

// MARK: - ViewModelCase
extension LoginViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany([
        appearFlow(with: input),
        viewLoadFlow(with: input)])
      .eraseToAnyPublisher()
  }
}

// MARK: - Input operator chain Flow
private extension LoginViewModel {
  func appearFlow(with input: Input) -> Output {
    return input
      .appear
      .tryMap { return .appear }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  func viewLoadFlow(with input: Input) -> Output {
    return input
      .viewLoad
      .tryMap { return .viewLoad }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
}
