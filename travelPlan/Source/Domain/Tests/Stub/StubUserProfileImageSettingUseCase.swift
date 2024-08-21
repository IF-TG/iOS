//
//  StubUserProfileImageSettingUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 8/17/24.
//

import Combine
import Foundation

struct StubUserProfileImageSettingUseCase: UserProfileImageSettingUseCase {
  func updateProfileImageData(with data: Data) -> AnyPublisher<Bool, any Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func saveProfileImageData(with data: Data) -> AnyPublisher<Bool, any Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteProfileImageData() -> AnyPublisher<Bool, any Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
}
