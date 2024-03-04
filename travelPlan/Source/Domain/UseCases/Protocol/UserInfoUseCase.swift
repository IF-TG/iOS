//
//  UserInfoUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

protocol UserInfoUseCase {
  var isNicknameDuplicated: PassthroughSubject<Bool, MainError> { get }
  var isNicknameUpdated: PassthroughSubject<Bool, MainError> { get }
  var isProfileUpdated: PassthroughSubject<Bool, MainError> { get }
  var isProfileSaved: PassthroughSubject<Bool, MainError> { get }
  
  func checkIfNicknameDuplicate(with name: String)
  func updateNickname(with name: String)
  func updateProfile(with base64String: String)
  func saveProfile(with base64String: String)
}
