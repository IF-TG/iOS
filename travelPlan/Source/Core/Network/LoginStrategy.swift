//
//  LoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine
import Alamofire

protocol LoginStrategy {
  var resultPublisher: PassthroughSubject<AuthenticationResponseValue, AuthenticationServiceError> { get }
  var session: Sessionable? { get set }
  func login()
}
