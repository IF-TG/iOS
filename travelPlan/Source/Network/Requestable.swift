//
//  Requestable.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Alamofire

protocol Requestable {
  typealias Error = AFError
  associatedtype Params: Encodable
  var scheme: String { get }
  var host: String { get }
  var method: HTTPMethod { get }
  var prefixPath: String { get }
  /// get일땐 queryItems에 부착, post일때 httpbody에 추가. AF는
  var parameters: Params? { get }
  var headers: HTTPHeaders? { get }
}

extension Requestable {
  func makeRequest(with responseType: ResponseType) throws -> DataRequest {
    let baseURL = "\(scheme)://\(host)" + prefixPath + responseType.path
    guard method == .post else {
      return AF.request(baseURL, method: method, parameters: parameters)
    }
    return AF.request(
      baseURL,
      method: method,
      parameters: parameters,
      encoder: URLEncodedFormParameterEncoder.default)
  }
}
