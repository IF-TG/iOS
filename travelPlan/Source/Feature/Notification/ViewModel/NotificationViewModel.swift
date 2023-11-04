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
      didTapDeleteIconStream(input),
      refreshNotificationsStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension NotificationViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad.map { _ in .none }.eraseToAnyPublisher()
  }
  
  func didTapCellStream(_ input: Input) -> Output {
    return input.didTapCell.map { [weak self] index in
      // TODO: - 해당 포스트 아이디와 함꼐 상세 디테일 포스트 화면으로 이동해야합니다. 임시로 UUID
      // TODO: - 서버에 이 알림 확인했다고 해야합니다.
      self?.notifications[index].isChecked = true
      return .showDetailPostPage(postId: .init(), index: index)
    }.eraseToAnyPublisher()
  }
  
  func didTapDeleteIconStream(_ input: Input) -> Output {
    return input.didTapDeleteIcon.map { [weak self] indexPath in
      // TODO: - 서버한테 삭제하려는 item 보낸후에 삭제해야합니다.
      self?.notifications.remove(at: indexPath.row)
      return .deleteCell(indexPath, lastItems: self?.notifications.count ?? 0)
    }.eraseToAnyPublisher()
  }
  
  func refreshNotificationsStream(_ input: Input) -> Output {
    return input.refreshNotifications
      .subscribe(on: DispatchQueue.main)
      .delay(for: 1.2, scheduler: DispatchQueue.main)
      .map { [weak self] in
        let fetchedMockData = NotificationInfo(
          userName: "방금추가..",
          details: "따근따근한추가 \n잘 ~ 됨됨!!!!",
          duration: "300일",
          isChecked: false,
          type: .comment(postTitle: "리프레쉬"))
        self?.notifications.insert(fetchedMockData, at: 0)
        return .reloadNotifications(lastItems: self?.notifications.count ?? 0)
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