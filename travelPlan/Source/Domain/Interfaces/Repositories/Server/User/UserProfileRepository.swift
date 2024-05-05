//
//  UserProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/13/24.
//

import Foundation
import Combine

protocol UserProfileRepository {
  typealias ProfileImageData = Data
  func fetchProfileImageData(with userId: String) -> AnyPublisher<ProfileImageData, Error>
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, Error>
}
