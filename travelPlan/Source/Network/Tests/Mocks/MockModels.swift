//
//  MockModels.swift
//  travelPlan
//
//  Created by 양승현 on 10/15/23.
//

struct UserNameRequestDTO: Encodable {
  let name: String
  let id: Int
}

struct UserNameResponseDTO: Decodable {
  var status: String
}
