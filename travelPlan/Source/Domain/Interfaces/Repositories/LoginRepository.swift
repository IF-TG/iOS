//
//  LoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

protocol LoginRepository {
  func performLogin(type: OAuthType) -> AnyPublisher<Bool, Error>
}
