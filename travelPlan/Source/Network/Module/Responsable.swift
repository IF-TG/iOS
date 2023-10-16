//
//  Responsable.swift
//  travelPlan
//
//  Created by 양승현 on 10/14/23.
//

import Foundation

protocol Responsable {
  /// AF 요청 후 응답받을 반환 타입
  associatedtype ResponseDTO: Decodable
}
