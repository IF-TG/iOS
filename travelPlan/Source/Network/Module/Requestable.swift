//
//  Requestable.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Alamofire

protocol Requestable {
  typealias Error = AFError
  associatedtype Params
  var scheme: String { get }
  var host: String { get }
  var method: HTTPMethod { get }
  var prefixPath: String { get }
  /// get일땐 queryItems에 부착, post일때 httpbody에 추가.
  var parameters: Params? { get }
  var requestType: RequestType { get }
  var headers: HTTPHeaders? { get }
  var interceptor: RequestInterceptor? { get }
}

extension Requestable where Params: Encodable {
  var baseURL: String {
    "\(scheme)://\(host)" + prefixPath
  }
  
  var absoluteURL: String {
    baseURL + requestType.path
  }
  
  func makeRequest(with session: Session) throws -> DataRequest {
    guard method == .post else {
      return session.request(absoluteURL, method: method, parameters: parameters, interceptor: interceptor)
    }
    return session.request(
      absoluteURL,
      method: method,
      parameters: parameters,
      encoder: URLEncodedFormParameterEncoder.default,
      interceptor: interceptor)
  }
}
