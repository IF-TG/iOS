//
//  WhatsNewNotificationResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 6/17/24.
//

import Foundation

struct WhatsNewNotificationResponseDTO: Decodable {
  let title: String
  let date: Date
  let details: String
  
  func toDomain() -> NoticeEntity {
    return NoticeEntity(title: title, date: date, details: details)
  }
}
