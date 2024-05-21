//
//  DefaultUserNicknameSettingUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Combine
import Foundation

final class DefaultUserNicknameSettingUseCase {
  // MARK: - Dependencies
  private let userProfileSettingRepository: UserProfileSettingRepository
  
  init(
    userProfileSettingRepository: UserProfileSettingRepository
  ) {
    self.userProfileSettingRepository = userProfileSettingRepository
  }
}

// MARK: - UserNicknameSettingUseCase
extension DefaultUserNicknameSettingUseCase: UserNicknameSettingUseCase {
  func updateNickname(with name: String) -> AnyPublisher<Bool, any Error> {
    return userProfileSettingRepository.updateUserNickname(with: name)
  }
}
