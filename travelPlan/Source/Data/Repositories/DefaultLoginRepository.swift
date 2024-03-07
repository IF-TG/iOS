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
  
  // MARK: - LifeCycle
  init(session: Sessionable) {
    self.session = session
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LoginRepository
extension DefaultLoginRepository: LoginRepository {
  func fetchAuthToken(authCode: String, identityToken: String) -> AnyPublisher<Bool, MainError> {
    return Future<Bool, MainError> { promise in
      let requestDTO = LoginRequestDTO(authCode: authCode, identityToken: identityToken)
      let endpoint = LoginAPIEndPoints.getAppleAuthToken(requestDTO: requestDTO)
      self.session
        .request(endpoint: endpoint)
        .map { $0.result }
        .sink { completion in
          if case let .failure(error) = completion {
            print("DEBUG: \(error.localizedDescription)")
            promise(.failure(.networkError(error)))
          }
        } receiveValue: { responseDTO in
          KeychainManager.shared.add(
            key: KeychainKey.accessToken.rawValue,
            value: responseDTO.accessToken.data(using: .utf8)
          )
          KeychainManager.shared.add(
            key: KeychainKey.refreshToken.rawValue,
            value: responseDTO.refreshToken.data(using: .utf8)
          )
          promise(.success(true))
        }
        .store(in: &self.subscriptions)
    }.eraseToAnyPublisher()
  }
}
