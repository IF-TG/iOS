//
//  FirebaseAuthRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/18/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift

@frozen enum FirebaseAuthError: LocalizedError {
  case notExistCurrentUser
  case invalidAdditionalUserInfo
  case reference(ReferenceError)
  
  var errorDescription: String? {
    switch self {
    case .invalidAdditionalUserInfo:
      return "서버에서 오류가 발생되었습니다"
    case .reference(let referenceError):
      return referenceError.localizedDescription
    case .notExistCurrentUser:
      return "로그인하지 않은 사용자입니다"
    }
  }
}

protocol FirebaseAuthRepository {
  /// 파이어베이스에서 지원하는 로그인 제공업체의 경우
  func signIn(with credential: OAuthCredential) -> AnyPublisher<Bool, any Error>
  
  /// 파이어베이스 기본 Authentication
  func signIn(withEnail: String, password: String) -> AnyPublisher<Bool, any Error>
  func signUp(withEmail: String, password: String) -> AnyPublisher<Bool, any Error>
  
  func signOut() -> AnyPublisher<Void, FirebaseAuthError>
  
  /// 회원 탈퇴시에는 사용자가 올린 여행 후기 ,댓글, 찜 정보 등 제거해야합니다.
  func withdrawal() -> AnyPublisher<Void, any Error>
}

// MARK: - Utils
extension FirebaseAuthRepository {
  func isNewUser(with authResult: AuthDataResult) -> Result<Bool, FirebaseAuthError> {
    guard let additionalUserInfo = authResult.additionalUserInfo else {
      return .failure(.invalidAdditionalUserInfo)
    }
    return .success(additionalUserInfo.isNewUser)
  }
}
