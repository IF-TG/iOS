//
//  Endpoint.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import Alamofire

final class Endpoint<ResponseDTO>: NetworkInteractionable where ResponseDTO: Decodable {
  typealias Params = Encodable?
  
  var scheme: String
  var host: String
  var method: HTTPMethod
  var prefixPath: String
  var parameters: Params?
  var headers: HTTPHeaders?
  var interceptor: RequestInterceptor?
  
  init(
    scheme: String = "https",
    host: String = "호스트 미정",
    method: HTTPMethod = .get,
    prefixPath: String = "미정",
    headers: HTTPHeaders? = ["Content-Type": "application/json"],
    interceptor: RequestInterceptor? = nil
  ) {
    self.scheme = scheme
    self.host = host
    self.method = method
    self.prefixPath = prefixPath
    self.headers = headers
    self.interceptor = interceptor
  }
}
