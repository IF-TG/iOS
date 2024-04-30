//
//  UserProfileSaveRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation

struct UserProfileSaveRequestDTO: Encodable {
  let uid: String
  let nickname: String
  let profileImagePath: String
}
