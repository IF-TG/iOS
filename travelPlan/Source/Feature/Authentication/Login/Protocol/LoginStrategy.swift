//
//  LoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine

protocol LoginStrategy {
  var resultPublisher: PassthroughSubject<AuthenticationResponseValue, AuthenticationServiceError> { get }
  func login()
}
