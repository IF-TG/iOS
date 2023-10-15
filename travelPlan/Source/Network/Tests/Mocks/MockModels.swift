//
//  MockModels.swift
//  travelPlan
//
//  Created by 양승현 on 10/15/23.
//

struct UserNameRequestModel: Encodable {
  let name: String
  let id: Int
}

struct UserNameResponseModel: Decodable {
  var status: String
}
