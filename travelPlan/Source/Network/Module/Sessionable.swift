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
  // TODO: - Image download 추가해야 함. 킹피셔 라이브러리 파해쳐보자!!
}
