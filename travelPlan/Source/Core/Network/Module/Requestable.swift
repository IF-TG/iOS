//
//  Requestable.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Alamofire
import Foundation

protocol Requestable {
  typealias Error = AFError
  var scheme: String { get }
  var host: String { get }
  var method: HTTPMethod { get }
  /// get일땐 queryItems에 부착, post일때 httpbody에 추가.
  /// 하지만 서버 명세서에 따라서, 서버에 요청할 때 두 개의 파라미터 사용하는 경우가 있습니다.
  var parameters: [ParameterType]? { get }
  var requestType: RequestType { get }
  var headers: HTTPHeaders? { get }
  var interceptor: RequestInterceptor? { get }
}

extension Requestable {
  var baseURL: String {
    "\(scheme)://\(host)"
  }
  
  var baseURLWithRequestPath: String {
    baseURL + "/" + requestType.path
  }
  
  func makeRequest(from session: Session) throws -> DataRequest {
    /// HTTPMETHOD == post임에도 query, body param 둘 다 담아서 보내야 하는 경우
    if parameters?.count == 2 {
      return try makeRequestWhenParametersHave(from: session)
    }
    
    /// 일반적으로 서버에 보내야 할 Parameters 개수가 한개인 경우입니다.
    var requestDTO: Encodable?
    if let hasParameter = parameters?.first {
      if case .query(let encodable) = hasParameter { requestDTO = encodable }
      if case .body(let encodable) = hasParameter { requestDTO = encodable }
    }
    return session.request(
      baseURLWithRequestPath,
      method: method,
      parameters: requestDTO?.toDictionary,
      interceptor: interceptor)
  }
  
  private func makeRequestWhenParametersHave(from session: Session) throws -> DataRequest {
    guard var urlComponents = URLComponents(string: baseURLWithRequestPath) else {
      throw ReferenceError.other("URLComponents가 만들어지지 않음.")
    }
    var bodyParam: Encodable?
    guard let parameters else { throw ReferenceError.other("makeRequest의 parameter존재하지 않음") }
    for parameter in parameters {
      if case .query(let encodable) = parameter {
        if let dict = encodable?.toDictionary {
          let queryItems = dict.map { URLQueryItem(name: $0, value: "\($1)")}
          urlComponents.queryItems = queryItems
        }
      }
      if case .body(let encodable) = parameter {
        bodyParam = encodable
      }
    }
    return session.request(
      urlComponents,
      method: method,
      parameters: bodyParam?.toDictionary,
      interceptor: interceptor)
  }
}
