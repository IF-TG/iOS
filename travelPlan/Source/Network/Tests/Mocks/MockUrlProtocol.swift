//
//  MockSession.swift
//  travelPlan
//
//  Created by 양승현 on 10/15/23.
//

import Foundation

class MockUrlProtocol: URLProtocol {
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    <#code#>
  }
  
  override func stopLoading() {
    
  }
}
