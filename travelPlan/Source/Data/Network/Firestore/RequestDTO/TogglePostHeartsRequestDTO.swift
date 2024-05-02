//
//  TogglePostHeartsRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/3/24.
//

import Foundation
import FirebaseFirestore

struct TogglePostHeartsRequestDTO: Encodable {
  let likeNum: FieldValue
}
