//
//  Endpoint.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import Alamofire

final class Endpoint<ResponseDTO>: NetworkInteractionable where ResponseDTO: Decodable {
  // MARK: - Properties
  var scheme: String
  var host: String
  var method: HTTPMethod
  var parameters: [ParameterType]?
  var requestType: RequestType
  var headers: HTTPHeaders?
  var interceptor: RequestInterceptor?
  
  // MARK: - Lifecycle
  init(
    scheme: String = "https",
    host: String = "호스트 미정",
    method: HTTPMethod = .get,
    parameters: [ParameterType]?,
    requestType: RequestType,
    headers: HTTPHeaders? = ["Content-Type": "application/json"],
    interceptor: RequestInterceptor? = nil
  ) {
    self.scheme = scheme
    self.host = host
    self.method = method
    self.parameters = parameters
    self.requestType = requestType
    self.headers = headers
    self.interceptor = interceptor
  }
}
