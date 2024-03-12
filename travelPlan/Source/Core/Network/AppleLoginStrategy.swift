//
//  AppleLoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import UIKit
import AuthenticationServices
import Combine
import Alamofire

final class AppleLoginStrategy: NSObject, LoginStrategy {
  // MARK: - Properties
  weak var viewController: UIViewController?
  let resultPublisher = PassthroughSubject<JWTResponseDTO, MainError>()
  private var authorizationController: ASAuthorizationController?
  var session: Sessionable?
  private var subscriptions = Set<AnyCancellable>()
  
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
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let authorizationCode = credential.authorizationCode,
          let identityToken = credential.identityToken else { return }
    let requestDTO = LoginRequestDTO(
      authorizationCode: authorizationCode.base64EncodedString(),
      identityToken: identityToken.base64EncodedString()
    )
    let endpoints = LoginAPIEndPoints.getAppleAuthToken(requestDTO: requestDTO)
    session?
      .request(endpoint: endpoints)
      .sink(receiveCompletion: { [weak self] completion in
        if case .failure(let error) = completion {
          self?.resultPublisher.send(completion: .failure(.networkError(error)))
        }
      }, receiveValue: { [weak self] responseDTO in
        self?.resultPublisher.send(responseDTO)
      })
      .store(in: &subscriptions)
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    // TODO: - 해당 에러에 대응하는 로직을 추가해야합니다.
//    resultPublisher.send(completion: .failure(.networkError(에러주입)))
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
