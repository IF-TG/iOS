//
//  MyInformationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Foundation
import Combine

struct MyInformationViewModel {
  struct Input {
    let isNicknameDuplicated: PassthroughSubject<String, MainError> = .init()
  }
  
  enum State {
    case none
    case duplicatedNickname
    case availableNickname
  }
  
  // MARK: - Dependencies
  private let userInfoUseCase: UserInfoUseCase
  
  // MARK: - Properties
  
  // MARK: - Lifecycle
  init(userInfoUseCase: UserInfoUseCase) {
    self.userInfoUseCase = userInfoUseCase
  }
}

// MARK: - MyInformationViewModelable
extension MyInformationViewModel: MyInformationViewModelable {
  func transform(_ input: Input) -> Output {
    let isDuplicatedUserName = isDuplicatedUserNameStream(input: input)
    let checkDuplicatedUserName = checkDuplicatedUserNameStream()
    return Publishers.MergeMany([
      isDuplicatedUserName,
      checkDuplicatedUserName]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension MyInformationViewModel {
  func isDuplicatedUserNameStream(input: Input) -> Output {
    return input.isNicknameDuplicated.map { nickname in
      userInfoUseCase.checkIfNicknameDuplicate(with: nickname)
      return .none
    }.eraseToAnyPublisher()
  }
  
  func checkDuplicatedUserNameStream() -> Output {
    userInfoUseCase.isNicknameDuplicated.map { isDuplicatedUserName -> State in
      return isDuplicatedUserName ? .duplicatedNickname : .availableNickname
    }.eraseToAnyPublisher()
  }
}