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
  var queryParams: Encodable? { get }
  var bodyParams: Encodable? { get }
  var headers: HTTPHeaders? { get }
}

extension Requestable {
  func makeURL(with responseType: ResponseType) throws -> URL {
    let baseURL = "\(scheme)://\(host)" + prefixPath + responseType.path
    guard var components = URLComponents(string: baseURL) else {
      throw Error.invalidURL(url: baseURL)
    }
    components.queryItems = queryParams?.makeQueryItems()
    return try components.asURL()
  }
}
