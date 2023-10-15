//
//  Requestable.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Alamofire

protocol Requestable {
  typealias Error = AFError
  var scheme: String { get }
  var host: String { get }
  var method: HTTPMethod { get }
  var prefixPath: String { get }
  /// get일땐 queryItems에 부착, post일때 httpbody에 추가.
  var parameters: Encodable? { get }
  var requestType: RequestType { get }
  var headers: HTTPHeaders? { get }
  var interceptor: RequestInterceptor? { get }
}

extension Requestable {
  var baseURL: String {
    "\(scheme)://\(host)" + prefixPath
  }
  
  var baseURLWithRequestPath: String {
    baseURL + requestType.path
  }
  
  func makeRequest(from session: Session) throws -> DataRequest {
    return session.request(
      baseURLWithRequestPath,
      method: method,
      parameters: parameters?.toDictionary,
      interceptor: interceptor)
  }
}
