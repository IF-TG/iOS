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
  let resultPublisher = PassthroughSubject<AuthenticationResponseValue, AuthenticationServiceError>()
  private var authorizationController: ASAuthorizationController?
  
  // MARK: - LifeCycle
  init(viewController: UIViewController) {
    self.viewController = viewController
  }
  
  func login() {
    let idProvider = ASAuthorizationAppleIDProvider()
    let request = idProvider.createRequest()
    request.requestedScopes = [.fullName]
    
    authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController?.delegate = self
    authorizationController?.presentationContextProvider = self
    authorizationController?.performRequests()
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
        let authResponse = AuthenticationResponseValue(
          authorizationCode: authorizationCode.base64EncodedString(),
          identityToken: identityToken.base64EncodedString()
        )
        resultPublisher.send(authResponse)
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
    guard let vc = viewController, let window = vc.view.window else {
      fatalError("viewController가 nil입니다.")
    }
    return window
  }
}