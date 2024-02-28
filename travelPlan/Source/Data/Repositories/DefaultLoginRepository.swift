//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

final class DefaultLoginRepository: LoginRepository {
  func fetchAuthToken(authCode: String, identityToken: String) -> AnyPublisher<AuthToken, Never> {
    let requestDTO = LoginRequestDTO(authCode: authCode, identityToken: identityToken)
    
  }
}
