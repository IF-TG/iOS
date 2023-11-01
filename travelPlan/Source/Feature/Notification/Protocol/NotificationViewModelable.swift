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
  let didTapCellDelete: PassthroughSubject<IndexPath, Never>
}

enum NotificationViewState {
  case none
  case reloadNotifications
  case deleteCell(IndexPath)
}

protocol NotificationViewModelable: ViewModelable
where Input == NotificationViewInput,
      State == NotificationViewState,
      Output == AnyPublisher<State, Never> {}
