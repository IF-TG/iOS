//
//  NoticeResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Foundation

struct NoticeResponseDTO: Decodable {
  let id: Int
  let title: String
  let date: String
  let details: String
  
  private enum CodingKeys: String, CodingKey {
    case id = "identifier"
    case title
    case date = "notice_date"
    case details
  }
}

extension NoticeResponseDTO {
  var toDomain: NoticeEntity {
    return .init(title: title, date: date, details: details)
  }
}
