//
//  LoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine

protocol LoginStrategy {
  var loginPublisher: PassthroughSubject<AuthToken, AuthServiceError> { get }
  func login()
}
