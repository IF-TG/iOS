//
//  UserRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/13/24.
//

import Foundation
import Combine

protocol UserRepository {
  func fetchProfile(with id: Int64) -> Future<ProfileImageEntity, MainError>
}
