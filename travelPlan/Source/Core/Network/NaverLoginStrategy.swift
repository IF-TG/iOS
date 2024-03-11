//
//  NaverLoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/10/24.
//

import Foundation
import Combine

final class NaverLoginStrategy: LoginStrategy {
  let resultPublisher = PassthroughSubject<AuthenticationResponseValue, AuthenticationServiceError>()
  
  func login() {
    let endpoint = LoginAPIEndPoints.getFirstRedirectUrlOfNaver()
    self.session.request(endpoint: endpoint)
    
  }
}
