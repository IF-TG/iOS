//
//  FirestoreWhatsNewNotificaitonEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 6/17/24.
//

import Foundation

struct FirestoreWhatsNewNotificaitonEndpoint {
  private init() {}
  
  static func makeWhatsNewNotificationFetchkEndpoint(
  ) -> FirestoreEndpoint<[WhatsNewNotificationResponseDTO]> {
    return FirestoreEndpoint<[WhatsNewNotificationResponseDTO]>(
      method: .get,
      requestType: .whatsNewNotifications)
  }
}
