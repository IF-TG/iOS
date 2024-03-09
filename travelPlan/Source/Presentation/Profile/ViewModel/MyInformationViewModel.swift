//
//  MyInformationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Foundation
import Combine

final class MyInformationViewModel {
  struct Input {
    let isNicknameDuplicated: PassthroughSubject<String, MainError> = .init()
    let tapStoreButton: PassthroughSubject<Void, MainError> = .init()
  }
  
  enum State {
    case none
    case networkProcessing
    case duplicatedNickname
    case availableNickname
    case correctionSaved
    case correctionNotSaved
  }
  
  // MARK: - Dependencies
  private let userInfoUseCase: UserInfoUseCase
  
  // MARK: - Properties
  private var hasProfileChanged = false
  private var changedNameAvailable = false
  
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
    return input.isNicknameDuplicated.map { [weak self] nickname in
      self?.userInfoUseCase.checkIfNicknameDuplicate(with: nickname)
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
  
  func checkDuplicatedUserNameStream() -> Output {
    userInfoUseCase.isNicknameDuplicated.map { [weak self] isDuplicatedUserName -> State in
      self?.changedNameAvailable = isDuplicatedUserName
      return isDuplicatedUserName ? .duplicatedNickname : .availableNickname
    }.eraseToAnyPublisher()
  }
  
  func tapStoreButtonStream(input: Input) -> Output {
    return input.tapStoreButton.map { _ -> State in
      
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
}
