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
    let isDuplicatedUserName: PassthroughSubject<String, Never>
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
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return input.isDuplicatedUserName.map { _ in
      return .none
    }.eraseToAnyPublisher()
  }
}
