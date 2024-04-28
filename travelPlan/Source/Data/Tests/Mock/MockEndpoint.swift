//
//  MockEndpoint.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/24/24.
//

import Foundation
import Alamofire

struct VoidResponseDTO: Decodable {}

struct MockRelativeURLPathProvider: RelativeURLPathProvidable {
  var path: String = ""
}

final class MockEndpoint<ResponseDTO>: NetworkInteractionable where ResponseDTO: Decodable {
  var scheme: String = ""
  var host: String = ""
  var method: Alamofire.HTTPMethod = .get
  var parameters: [ParameterType]?
  var requestType: any RelativeURLPathProvidable = MockRelativeURLPathProvider()
  var headers: Alamofire.HTTPHeaders?
  var interceptor: (any Alamofire.RequestInterceptor)?
}

struct mockEndpointProvider {
  static func make() -> MockEndpoint<TourApiCommonResponseDTO<VoidResponseDTO>> {
    return .init()
  }
}
