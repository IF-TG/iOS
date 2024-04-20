//
//  CommonDTO.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation

// result에 실제 서버에서 응답하는 데이터가 담깁니다. 그래서 CommonDTO를 사용할 때 T의 구체 타입을 명시해야 합니다.
struct CommonDTO<T: Decodable>: Decodable {
  let result: T
  let status: String
  let statusCode: String
  let message: String
}
