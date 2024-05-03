//
//  TogglePostHeartsRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/3/24.
//

import Foundation
import FirebaseFirestore

struct TogglePostHeartsRequestDTO {
  let likeNum: FieldValue
  
  func toDict() -> [String: Any] {
    return [
      "likeNum": likeNum
    ] as [String: Any]
  }
}
