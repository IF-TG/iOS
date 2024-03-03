//
//  AppleLoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import UIKit
import AuthenticationServices
import Combine

final class AppleLoginStrategy: NSObject, LoginStrategy {
  
  // MARK: - Properties
  weak var viewController: UIViewController?
  let loginPublisher = PassthroughSubject<AuthToken, AuthServiceError>()
  
  // MARK: - LifeCycle
  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func login() {
    let idProvider = ASAuthorizationAppleIDProvider()
    let request = idProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleLoginStrategy: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      if let authorizationCode = credential.authorizationCode,
         let identityToken = credential.identityToken {
        let authString = authorizationCode.base64EncodedString()
        let tokenString = identityToken.base64EncodedString()
        let authToken = AuthToken(accessToken: authString, refreshToken: tokenString)
        loginPublisher.send(authToken)
      }
    }
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    print("handle error: \(error.localizedDescription)")
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleLoginStrategy: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return viewController?.view.window ?? .init()
  }
}
