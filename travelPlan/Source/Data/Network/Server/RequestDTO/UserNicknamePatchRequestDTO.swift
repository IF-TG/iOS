//
//  UserNicknamePatchRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 2/29/24.
//

import Foundation

struct UserNicknamePatchRequestDTO: Encodable {
  let nickname: String
  let userId: Int64
}
