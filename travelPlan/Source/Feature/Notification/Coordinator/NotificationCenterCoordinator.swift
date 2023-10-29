//
//  NotificationCenterCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 10/27/23.
//

import UIKit
import SHCoordinator

protocol NotificationCenterCoordinatorDelegate: AnyObject {
  func finish()
}

final class NotificationCenterCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController!
  
  // MARK: - Lifecycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  func start() {
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

    let mockSession = MockSession.default
    let service = SessionProvider(session: mockSession)
    let notificationRepository = DefaultNotificationRepository(service: service)
    let noticeUseCase = DefaultNoticeUseCase(notificationRepository: notificationRepository)
    let noticeViewModel = NoticeViewModel(noticeUseCase: noticeUseCase)
    let vc = NotificationCenterViewController(noticeViewModel: noticeViewModel)
    vc.coordinator = self
    presenter.pushViewController(vc, animated: true)
  }
  
  deinit {
    print("\(Self.self) deinit" )
  }
}

// MARK: - NotificationCenterCoordinatorDelegate
extension NotificationCenterCoordinator: NotificationCenterCoordinatorDelegate { }
