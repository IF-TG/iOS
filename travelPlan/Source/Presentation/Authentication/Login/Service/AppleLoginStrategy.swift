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
  override init() {
    super.init()
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
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .compactMap { $0 as? UIWindowScene }
      .first!.windows
      .filter { $0.isKeyWindow }.first!
  }
}
