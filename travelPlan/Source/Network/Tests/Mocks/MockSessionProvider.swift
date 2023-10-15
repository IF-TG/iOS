//
//  MockSessionProvider.swift
//  travelPlan
//
//  Created by 양승현 on 10/15/23.
//

import Alamofire

class MockSessionProvider {
  static var session: Session {
    let configuration = URLSessionConfiguration.af.default
    configuration.protocolClasses = [MockUrlProtocol.self] + (configuration.protocolClasses ?? [])
    return Session(configuration: configuration)
  }
}
