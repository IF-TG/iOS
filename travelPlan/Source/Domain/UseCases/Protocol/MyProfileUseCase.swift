//
//  MyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

protocol MyProfileUseCase {
  var isNicknameDuplicated: PassthroughSubject<Bool, MainError> { get }
  var isNicknameUpdated: PassthroughSubject<Bool, MainError> { get }
  var isProfileUpdated: PassthroughSubject<Bool, MainError> { get }
  var isProfileSaved: PassthroughSubject<Bool, MainError> { get }
  var isProfileDeleted: PassthroughSubject<Bool, MainError> { get }
  var fetchedProfile: PassthroughSubject<ProfileImageEntity, MainError> { get }
  var isProfileSavedInServer: Bool { get }
  
  func checkIfNicknameDuplicate(with name: String)
  func updateNickname(with name: String)
  func updateProfile(with base64String: String)
  func saveProfile(with base64String: String)
  func deleteProfile()
  func fetchProfile()
}
