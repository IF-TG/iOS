//
//  DefaultNicknameValidationUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Foundation

final class DefaultNicknameValidationUseCase {
  // MARK: - Dependencies
  private let userProfileSettingRepository: UserProfileSettingRepository
  
  init(
    userProfileSettingRepository: UserProfileSettingRepository
  ) {
    self.userProfileSettingRepository = userProfileSettingRepository
  }
}

// MARK: - NicknameValidationUseCase
extension DefaultNicknameValidationUseCase: NicknameValidationUseCase {
  func isNicknameDuplicated(with name: String) -> AnyPublisher<Bool, any Error> {
    userProfileSettingRepository.checkIfUserNicknameDuplicate(with: name)
  }
  
  func validateNickname(_ nickname: String) -> AnyPublisher<NicknameValidateState, Never> {
    <#code#>
  }
}
