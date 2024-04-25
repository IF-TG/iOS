//
//  GoogleLoginStrategyWithFirebase.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import Combine

@frozen enum GoogleLoginStrategyError: LocalizedError {
  case invalidClientIdInFirebase
  case invalidPresentingViewController
  case invalidUserInfoInGoogle
  case googleSignInError(Error)
}

final class GoogleLoginStrategyWithFirebase: LoginStrategy {
  var resultPublisher: PassthroughSubject<JWTResponseDTO?, any Error> = .init()
  
  var sessionable: (any Sessionable)?
  
  func login() {
    guard let clientId = FirebaseApp.app()?.options.clientID else {
      resultPublisher.send(completion: .failure(GoogleLoginStrategyError.invalidClientIdInFirebase))
      return
    }
    
    var presentingVC: UIViewController?
    if #available(iOS 15.0 , *) {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let viewController = windowScene.windows.first?.rootViewController?.presentedViewController {
        presentingVC = viewController
      }
    } else if #available(iOS 13.0, *) {
      if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow } ),
         let viewController = window.rootViewController?.presentedViewController {
        presentingVC = viewController
      }
    } else {
      presentingVC = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController
    }
    
    guard let presentingVC else {
      resultPublisher.send(completion: .failure(GoogleLoginStrategyError.invalidPresentingViewController))
      return
    }
    
    let config = GIDConfiguration(clientID: clientId)
    GIDSignIn.sharedInstance.configuration = config
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
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
        // 로그인 완료
        self?.resultPublisher.send(nil)
      }
    }
  }
}
