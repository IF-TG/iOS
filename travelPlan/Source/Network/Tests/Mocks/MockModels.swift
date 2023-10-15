//
//  MockModels.swift
//  travelPlan
//
//  Created by 양승현 on 10/15/23.
//

struct UserNameUpdateRequestModel: Encodable {
  let name: String
  let id: Int
}

struct UserNameUpdateResponseModel: Decodable {
  var status: Bool
}
