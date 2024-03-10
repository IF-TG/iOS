//
//  MockUserInfoUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/11/24.
//

import Foundation
import Combine

final class MockUserInfoUseCase: UserInfoUseCase {
  
  init() {
    // Mock session주입
    let mockSession = MockSession.default
    let sessionProvider = SessionProvider(session: mockSession)
    let userInfoRepository = DefaultUserInfoRepository(service: sessionProvider)
    defaultUserInfoUseCase = DefaultUserInfoUseCase(userInfoRepository: userInfoRepository)
  }
  private let defaultUserInfoUseCase: UserInfoUseCase
  
  var isNicknameDuplicated: PassthroughSubject<Bool, MainError> {
    defaultUserInfoUseCase.isNicknameDuplicated
  }
  
  var isNicknameUpdated: PassthroughSubject<Bool, MainError> {
    defaultUserInfoUseCase.isNicknameUpdated
  }
  
  var isProfileUpdated: PassthroughSubject<Bool, MainError> {
    defaultUserInfoUseCase.isProfileUpdated
  }
  
  var isProfileSaved: PassthroughSubject<Bool, MainError> {
    defaultUserInfoUseCase.isProfileSaved
  }
  
  var isProfileDeleted: PassthroughSubject<Bool, MainError> {
    defaultUserInfoUseCase.isProfileDeleted
  }
  
  var fetchedProfile: PassthroughSubject<ProfileImageEntity, MainError> {
    defaultUserInfoUseCase.fetchedProfile
  }
  
  func checkIfNicknameDuplicate(with name: String) {
    let json = """
          {
            "result": false,
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    defaultUserInfoUseCase.checkIfNicknameDuplicate(with: name)
  }
  
  func updateNickname(with name: String) {
    let json = """
          {
            "result": true,
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    defaultUserInfoUseCase.updateNickname(with: name)
  }
  
  func updateProfile(with base64String: String) {
    let json = """
          {
            "result": {
              imageUrl: \(base64String),
              userId: 1
            },
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    defaultUserInfoUseCase.updateProfile(with: base64String)
  }
  
  func saveProfile(with base64String: String) {
    let json = """
          {
            "result": {
              imageUrl: \(base64String),
              userId: 1
            },
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    defaultUserInfoUseCase.saveProfile(with: base64String)
  }
  
  func deleteProfile() {
    let json = """
          {
            "result": true,
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    defaultUserInfoUseCase.deleteProfile()
  }
  
  func fetchProfile() {
    let json = """
          {
            "result": {
              imageUrl: "베이스64인코딩된이미지문자열....",
              userId: 1
            },
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """

    defaultUserInfoUseCase.fetchProfile()
  }
}
