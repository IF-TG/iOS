//
//  MockSession.swift
//  travelPlan
//
//  Created by 양승현 on 10/15/23.
//

import Alamofire
import Foundation

class MockSession {
  static var `default`: Session {
    let configuration = URLSessionConfiguration.af.default
    configuration.protocolClasses = [MockUrlProtocol.self] + (configuration.protocolClasses ?? [])
    return Session(configuration: configuration)
  }
}
