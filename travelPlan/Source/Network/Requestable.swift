//
//  Requestable.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation
import Alamofire

protocol Requestable {
  typealias Error = AFError
  var scheme: String { get }
  var host: String { get }
  var method: HTTPMethod { get }
  var prefixPath: String { get }
  var suffixPath: ResponseType { get }
  var queryParams: Parameters? { get }
  var bodyParams: Parameters? { get }
  var headers: HTTPHeaders? { get }
}
