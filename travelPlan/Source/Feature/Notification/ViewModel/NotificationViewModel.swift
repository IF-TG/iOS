//
//  NotificationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import Foundation
import Combine

final class NotificationViewModel {
  var notifications = NotificationInfo.mockData()
}

// MARK: - NotificationViewModelable
extension NotificationViewModel: NotificationViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      didTapCellStream(input),
      didTapDeleteIconStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension NotificationViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad.map { _ in .none }.eraseToAnyPublisher()
  }
  
  func didTapCellStream(_ input: Input) -> Output {
    return input.didTapCell.map { _ in
      // TODO: - 해당 포스트 아이디와 함꼐 상세 디테일 포스트 화면으로 이동해야합니다. 임시로 UUID
      return .showDetailPostPage(.init())
    }.eraseToAnyPublisher()
  }
  
  func didTapDeleteIconStream(_ input: Input) -> Output {
    return input.didTapDeleteIcon.map { [weak self] indexPath in
      // TODO: - 서버한테 삭제하려는 item 보낸후에 삭제해야합니다.
      self?.notifications.remove(at: indexPath.row)
      return .deleteCell(indexPath, lastItems: self?.notifications.count ?? 0)
    }.eraseToAnyPublisher()
  }
}

// MARK: - NotificationViewAdapterDataSource
extension NotificationViewModel: NotificationViewAdapterDataSource {
  var numberOfItems: Int {
    notifications.count
  }
  
  func getItem(_ indexPath: IndexPath) -> NotificationInfo {
    notifications[indexPath.row]
  }
}
