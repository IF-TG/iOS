//
//  InterceptedWhatsNewNotificationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 6/18/24.
//

import Combine
import Foundation

struct InterceptedWhatsNewNotificationRepository: WhatsNewNotificationRepository {
  private let whatsNewNotificationRepository = DefaultWhatsNewNotificationRepository(
    service: SessionProvider(session: MockSession.default))
  
  func fetchNotices() -> AnyPublisher<[NoticeEntity], any Error> {
    MockUrlProtocol.requestHandler = { request in
      guard let path = Bundle.main.path(forResource: "mock_response_notice", ofType: "json") else {
        return ((HTTPURLResponse(), Data()))
      }
      guard let jsonStr = try? String(contentsOfFile: path) else {
        return ((HTTPURLResponse(), Data()))
      }
      let responseData = jsonStr.data(using: .utf8)!
      let mockURL = request.url!
      let urlResponse = HTTPURLResponse(url: mockURL, statusCode: 203, httpVersion: nil, headerFields: nil)!
      return ((urlResponse, responseData))
    }
    return whatsNewNotificationRepository.fetchNotices()
  }
}
