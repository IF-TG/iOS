//
//  MockMyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/11/24.
//

import Foundation
import Combine

final class MockMyProfileUseCase: MyProfileUseCase {
  init() {
    // Mock session주입
    let mockSession = MockSession.default
    let sessionProvider = SessionProvider(session: mockSession)
    let myProfileRepository = DefaultMyProfileRepository(service: sessionProvider)
    defaultMyProfileUseCase = DefaultMyProfileUseCase(myProfileRepository: myProfileRepository)
  }
  
  private let defaultMyProfileUseCase: MyProfileUseCase
  
  var isProfileSavedInServer: Bool {
    defaultMyProfileUseCase.isProfileSavedInServer
  }
  
  var isNicknameDuplicated: PassthroughSubject<Bool, MainError> {
    defaultMyProfileUseCase.isNicknameDuplicated
  }
  
  var isNicknameUpdated: PassthroughSubject<Bool, MainError> {
    defaultMyProfileUseCase.isNicknameUpdated
  }
  
  var isProfileUpdated: PassthroughSubject<Bool, MainError> {
    defaultMyProfileUseCase.isProfileUpdated
  }
  
  var isProfileSaved: PassthroughSubject<Bool, MainError> {
    defaultMyProfileUseCase.isProfileSaved
  }
  
  var isProfileDeleted: PassthroughSubject<Bool, MainError> {
    defaultMyProfileUseCase.isProfileDeleted
  }
  
  var fetchedProfile: PassthroughSubject<ProfileImageEntity, MainError> {
    defaultMyProfileUseCase.fetchedProfile
  }
  
  func checkIfNicknameDuplicate(with name: String) {
    var mockResult = false
    if name == "무야호" {
      /// 무야호일 경우 중복된 이름.
      mockResult = true
    }
    let json = """
          {
            "result": \(mockResult),
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      self.defaultMyProfileUseCase.checkIfNicknameDuplicate(with: name)
    }
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
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      self.defaultMyProfileUseCase.updateNickname(with: name)
    }
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
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      self.defaultMyProfileUseCase.updateProfile(with: base64String)
    }
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
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      self.defaultMyProfileUseCase.saveProfile(with: base64String)
    }
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
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      self.defaultMyProfileUseCase.deleteProfile()
    }
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
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
      self.defaultMyProfileUseCase.fetchProfile()
    }
  }
}
