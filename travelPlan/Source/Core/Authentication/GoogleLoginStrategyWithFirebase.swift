//
//  GoogleLoginStrategyWithFirebase.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import SHFirestoreService
import Combine

@frozen enum GoogleLoginStrategyError: LocalizedError {
  case invalidClientIdInFirebase
  case invalidPresentingViewController
  case invalidUserInfoInGoogle
  case googleSignInError(Error)
  case faildLoggedInFirebaseAuth(Error)
}

final class GoogleLoginStrategyWithFirebase: LoginStrategy {
  var resultPublisher: PassthroughSubject<JWTResponseDTO?, any Error> = .init()
  
  var sessionable: (any Sessionable)?
  
  private let firestoreService = FirestoreService()
  
  private var subscription: AnyCancellable?
  
  // MARK: - Helpers
  func login() {
    guard let clientId = FirebaseApp.app()?.options.clientID else {
      resultPublisher.send(completion: .failure(GoogleLoginStrategyError.invalidClientIdInFirebase))
      return
    }

    guard let presentedVC = UIApplication.topPresentedViewController else {
      resultPublisher.send(completion: .failure(GoogleLoginStrategyError.invalidPresentingViewController))
      return
    }
    
    let config = GIDConfiguration(clientID: clientId)
    GIDSignIn.sharedInstance.configuration = config
    GIDSignIn.sharedInstance.signIn(withPresenting: presentedVC) { [weak self] result, error in
      /// 사용자가 취소할 경우 or 기타 에러
      if let error {
        self?.resultPublisher.send(completion: .failure(GoogleLoginStrategyError.googleSignInError(error)))
        return
      }
      
      guard 
        let user = result?.user,
        let idToken = user.idToken?.tokenString
      else {
        self?.resultPublisher.send(completion: .failure(GoogleLoginStrategyError.invalidUserInfoInGoogle))
        return
      }
      
      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: user.accessToken.tokenString)
      
      Auth.auth().signIn(with: credential) { result, error in
        if let error {
          self?.resultPublisher.send(completion: .failure(GoogleLoginStrategyError.faildLoggedInFirebaseAuth(error)))
          return
        }
        
        /// 첫 사용자인가?
        /// 현재 firestore를 사용하지 않고 다시 spring server를 사용하기로 했으므로 uid는 -1을 넣습니다.
        ///    result?.user.uid를 사용해야합니다.
        if result?.additionalUserInfo?.isNewUser == true, result?.user.uid != nil {
          let requestDTO = UserProfileSaveRequestDTO(
            uid: -1,
            nickname: "여행자",
            profileImagePath: "")
          
          // MARK: - UserProfileSEttingUseCase나 레포지토리 사용해야합니다.
          /// 그러나 현재 firestore service를 사용하지 않아 임시 보류합니다.
          let endpoint = FirestoreUserProfileSettingAPIEndopint.saveUserProfileEndpoint(with: requestDTO)
          self?.subscription = self?.firestoreService.request(endpoint: endpoint)
            .sink { completion in
              if case .failure(let error) = completion {
                self?.resultPublisher.send(completion: .failure(error))
              }
            } receiveValue: { _ in
              /// Auth에서 crednetial로 로그인 성공 및 첫 이용자인 경우 기본 사용자 정보 저장.
              self?.resultPublisher.send(nil)
            }
        } else {
          /// Auth에서 crednetial로 로그인 성공
          self?.resultPublisher.send(nil)
        }
      }
    }
  }
}
