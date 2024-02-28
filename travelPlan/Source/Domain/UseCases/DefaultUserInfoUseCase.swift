//
//  DefaultUserInfoUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class DefaultUserInfoUseCase: UserInfoUseCase {
  // MARK: - Dependencies
  private let userInfoRepository: UserInfoRepository
  
  // MARK: - Properties
  var isDuplicatedName = PassthroughSubject<Bool, Never>()
  
  var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(userInfoRepository: UserInfoRepository) {
    self.userInfoRepository = userInfoRepository
  }
  
  func isDuplicatedName(with name: String) {
    subscription = userInfoRepository.isDuplicatedName(with: name).sink { [weak self] in
      self?.isDuplicatedName.send($0)
    }
  }
}
