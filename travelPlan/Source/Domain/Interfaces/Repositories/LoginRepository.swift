//
//  LoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

protocol LoginRepository {
  func fetchAuthToken(
    authCode: String,
    identityToken: String
  ) -> AnyPublisher<AuthToken, Never>
}
