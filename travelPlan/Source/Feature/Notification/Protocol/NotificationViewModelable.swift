//
//  NotificationViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import Foundation
import Combine

struct NotificationViewInput {
  let viewDidLoad: PassthroughSubject<Void, Never>
  let didTapCell: PassthroughSubject<Int, Never>
  let didTapDeleteIcon: PassthroughSubject<IndexPath, Never>
}

enum NotificationViewState {
  case none
  case reloadNotifications(lastItems: Int)
  case deleteCell(IndexPath, lastItems: Int)
  // TODO: - 특정 post 상세 id와 함꼐화면 이동
  case showDetailPostPage(UUID)
}

protocol NotificationViewModelable: ViewModelable
where Input == NotificationViewInput,
      State == NotificationViewState,
      Output == AnyPublisher<State, Never> {}
