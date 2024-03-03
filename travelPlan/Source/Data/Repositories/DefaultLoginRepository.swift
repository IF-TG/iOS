//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

final class DefaultLoginRepository {
  // MARK: - Properties
  private let session: Sessionable
  private var subscriptions = Set<AnyCancellable>()
  private let keyChainManager: KeyChainManager
  
  // MARK: - LifeCycle
  init(session: Sessionable, keyChainManager: KeyChainManager) {
    self.session = session
    self.keyChainManager = keyChainManager
  }
}

// MARK: - LoginRepository
extension DefaultLoginRepository: LoginRepository {
  func fetchAuthToken(authCode: String, identityToken: String) -> AnyPublisher<Bool, Never> {
    return Future { promise in
      let requestDTO = LoginRequestDTO(authCode: authCode, identityToken: identityToken)
      let endpoint = LoginAPIEndPoints.getAppleAuthToken(requestDTO: requestDTO)
      self.session
        .request(endpoint: endpoint)
        .sink { completion in
          if case let .failure(error) = completion {
            print("DEBUG: \(error.localizedDescription)")
            promise(.success(false))
          }
        } receiveValue: { [weak self] response in
          guard let self = self else { return }
          keyChainManager.addToken(response.accessToken, forKey: .accessToken)
          keyChainManager.addToken(response.refreshToken, forKey: .refreshToken)
          promise(.success(true))
        }
        .store(in: &self.subscriptions)
    }.eraseToAnyPublisher()
  }
}
