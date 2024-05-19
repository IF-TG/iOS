//
//  DefaultUserProfileImageSettingUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Combine
import Foundation

final class DefaultUserProfileImageSettingUseCase {
  // MARK: - Dependencies
  private let userProfileSettingRepository: UserProfileSettingRepository
  
  // MARK: - Lifecycle
  init(
    userProfileSettingRepository: UserProfileSettingRepository
  ) {
    self.userProfileSettingRepository = userProfileSettingRepository
  }
}

// MARK: - UserProfileImageSettingUseCase
extension DefaultUserProfileImageSettingUseCase: UserProfileImageSettingUseCase {
  func updateProfileImageData(with data: Data) -> AnyPublisher<Bool, any Error> {
    return userProfileSettingRepository.updateProfileImage(with: data)
  }
  
  func saveProfileImageData(with data: Data) -> AnyPublisher<Bool, any Error> {
    return userProfileSettingRepository.saveProfileImage(with: data)
  }
  
  func deleteProfileImageData() -> AnyPublisher<Bool, any Error> {
    return userProfileSettingRepository.deleteProfileImage()
  }
}
