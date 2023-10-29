//
//  NotificationAPIEndpoints.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Foundation

struct NotificationAPIEndpoints {
  private init() {}
  static let `default` = NotificationAPIEndpoints()
  
  func fetchNotices() -> Endpoint<NoticeResponseDTO> {
    return Endpoint<NoticeResponseDTO>(
      prefixPath: "temp",
      parameters: nil,
      requestType: .none)
  }
}
