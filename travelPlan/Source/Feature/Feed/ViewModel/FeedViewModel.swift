//
//  FeedViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit
import Combine

// notificationArrivedTODO: - NotificationIcon render
/// - 로그인한 사용자한테 오는 알림을 감지했다 알림이 오면 view 한테 상태 업데이트해야 합니다.
/// - 그 상태 변화는 Feed에 있을 때, 5초에한번씩 서버로부터 확인한다든지 등등..
/// 확인이 될 경우엔 notificationArrived 상태값을 true로 변경합니다.
/// - true로 변경됬을 때,
/// 영구저장소에는 isCheckedNotification을 false로 합니다.
/// 그리고 ui state를 updateNotificationRedIcon로 변경합니다.
final class FeedViewModel: ViewModelCase {
  // MARK: - Properteis
  @Published private var isNotificationArrived = false
  
  private var updateNotificatinoRedIcon = PassthroughSubject<Void, ErrorType>()
  var subscription = Set<AnyCancellable>()
}

extension FeedViewModel {
  func transform(_ input: Input) -> Output {
    bind()
    return Publishers
      .MergeMany([
        appearChains(input),
        didTapNotificationChains(input),
        didTapPostSearch(input),
        updateNotificationRedIconChains()])
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
fileprivate extension FeedViewModel {
  func bind() {
    /// 알림이 올 경우 isNotificationArrived 값을 true로 해야 합니다.
    $isNotificationArrived.sink { [weak self] value in
      // 만약 notificationArrived가 true인 경우에 한 해서만 output 신호를 보냅니다.
      if value {
        self?.updateNotificatinoRedIcon.send()
      }
    }.store(in: &subscription)
  }
}

// MARK: - Operator chains
fileprivate extension FeedViewModel {
  func updateNotificationRedIconChains() -> Output {
    /// 알림이 왔다면 notificationArrived 값을 true로 하고, 이 함수가 호출될 것입니다.
    updateNotificatinoRedIcon
      .subscribe(on: RunLoop.main)
      .map { [weak self] _ -> State in
        self?.isNotificationArrived = false
        return .updateNotificationRedIcon
      }.mapError { $0 as? ErrorType ?? .none }
      .eraseToAnyPublisher()
  }
  
  func appearChains(_ input: Input) -> Output {
    return input
      .appear
      .subscribe(on: RunLoop.main)
      .tryMap { _ -> State in
        /// 이곳에서 영구저장소에 사용자가 알림을 확인했는지 확인해야합니다.
        /// 임시적으로 지금은 뷰가 나타났을 때 알림이 왔다는 가정을 했습니다. .none으로 할 경우 redIcon 사라집니다.
        return .viewAppear(userNotificationState: .notChecked)
      }.mapError { error in
        return error as? ErrorType ?? .none
      }.eraseToAnyPublisher()
  }
  
  func didTapNotificationChains(_ input: Input) -> Output {
    return input
      .didTapNotification
      .subscribe(on: RunLoop.main)
      .tryMap { _ -> State in
        /// 이곳에서 영구저장소에 사용자가 알림을 확인했는지 확인해야 합니다.
        /// 그리고 확인된 값을 반환해야 합니다.
        /// 지금은 임시적으로 일관된 값을 반환합니다.
        return .goToNotification
      }.mapError { return $0 as? ErrorType ?? .none }
      .eraseToAnyPublisher()
  }
  
  func didTapPostSearch(_ input: Input) -> Output {
    return input
      .didTapPostSearch
      .subscribe(on: RunLoop.main)
      .tryMap { _ -> State in
        return .goToPostSearch
      }.mapError { $0 as? ErrorType ?? .none }
      .eraseToAnyPublisher()
  }
}
