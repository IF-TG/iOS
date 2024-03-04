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
  
  deinit {
    print("deinit: \(Self.self)")
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
        .map { $0.result }
        .sink { completion in
          if case let .failure(error) = completion {
            print("DEBUG: \(error.localizedDescription)")
            promise(.success(false))
          }
        } receiveValue: { [weak self] responseDTO in
          guard let self = self else { return }
          keyChainManager.addToken(responseDTO.accessToken, forKey: .accessToken)
          keyChainManager.addToken(responseDTO.refreshToken, forKey: .refreshToken)
          promise(.success(true))
        }
        .store(in: &self.subscriptions)
    }.eraseToAnyPublisher()
  }
}
