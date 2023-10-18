//
//  Sessionable.swift
//  travelPlan
//
//  Created by 양승현 on 10/14/23.
//

import Combine
import Alamofire

protocol Sessionable {
  func request<R, E>(endpoint: E) -> Future<R, AFError>
  where R: Decodable,
        E: NetworkInteractionable,
        R == E.ResponseDTO
}
