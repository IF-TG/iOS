//
//  UserProfileImageSettingUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Combine
import Foundation

protocol UserProfileImageSettingUseCase {
  func updateProfileImageData(with data: Data) -> AnyPublisher<Bool, Error>
  func saveProfileImageData(with data: Data) -> AnyPublisher<Bool, Error>
  func deleteProfileImageData() -> AnyPublisher<Bool, Error>
}
