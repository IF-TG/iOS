//
//  NotificationAPIEndpoints.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Foundation

struct NotificationAPIEndpoints {
  static func fetchNotices() -> Endpoint<[NoticeResponseDTO]> {
    return Endpoint<[NoticeResponseDTO]>(
      host: "v1/", 
      parameters: nil,
      requestType: .none)
  }
}
