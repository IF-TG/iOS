//
//  UserProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/13/24.
//

import Foundation
import Combine

protocol UserProfileRepository {
  func fetchProfileImageData(with userId: UserIdentifier) -> AnyPublisher<ProfileImageEntity, Error>
  func fetchProfile(with userId: UserIdentifier) -> AnyPublisher<UserEntity, Error>
}
