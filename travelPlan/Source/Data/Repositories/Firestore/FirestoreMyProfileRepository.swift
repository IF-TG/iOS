//
//  FirestoreMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation
import Combine

final class FirestoreMyProfileRepository: MyProfileRepository {
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func updateProfileImage(with profile: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func saveProfileImage(with profile: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func deleteProfileImage() -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func fetchProfileImage() -> AnyPublisher<ProfileImageEntity, any Error> {
    fatalError("아직 미구현")
  }
  
  var isProfileSavedInServer: Bool
  
  
}
