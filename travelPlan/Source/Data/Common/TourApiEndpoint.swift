//
//  TourApiEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Alamofire

final class TourApiEndpoint<ResponseDTO>: NetworkInteractionable where ResponseDTO: Decodable {
  var scheme: String = "https"
  var host: String = "apis.data.go.kr"
  var method: HTTPMethod = .get
  var parameters: [ParameterType]?
  var requestType: any RelativeURLPathProvidable
  var headers: HTTPHeaders?
  var interceptor: (any RequestInterceptor)?
  
  init(
    parameters: ParameterType,
    requestType: TourApiRequestType
  ) {
    self.parameters = [parameters]
    self.requestType = requestType
  }
}
