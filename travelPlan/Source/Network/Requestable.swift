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
  func makeRequest() throws -> DataRequest {
    let baseURL = "\(scheme)://\(host)" + prefixPath + requestType.path
    guard method == .post else {
      return AF.request(baseURL, method: method, parameters: parameters, interceptor: interceptor)
    }
    return AF.request(
      baseURL,
      method: method,
      parameters: parameters,
      encoder: URLEncodedFormParameterEncoder.default,
      interceptor: interceptor)
  }
}
