//
//  NaverLoginStrategy.swift
//  travelPlan
//
//  Created by SeokHyun on 3/10/24.
//

import Foundation
import Combine
import Alamofire

final class NaverLoginStrategy: LoginStrategy {
  var session: Sessionable?
  let resultPublisher = PassthroughSubject<AuthenticationResponseValue, AuthenticationServiceError>()
  
  func login() {
    let endpoint = LoginAPIEndPoints.getFirstRedirectURL()
    session?
      .request(endpoint: endpoint)
      .validate(<#T##validation: DataRequest.Validation##DataRequest.Validation##(URLRequest?, HTTPURLResponse, Data?) -> DataRequest.ValidationResult#>)
  }
}
