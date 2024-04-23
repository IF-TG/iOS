//
//  LoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine

protocol LoginStrategy {
  var resultPublisher: PassthroughSubject<JWTResponseDTO, Error> { get }
  var sessionable: Sessionable? { get set }
  func login()
}
