//
//  FeedViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import Combine
import Foundation

final class FeedViewModel {
  // MARK: - Properteis
  @Published private var isNotificationArrived = false
  private var updateNotificatinoRedIcon = PassthroughSubject<Void, Never>()
  var subscriptions = Set<AnyCancellable>()
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Lifecycle
  init(
    backgroundQueue: DispatchQueue
  ) {
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - FeedViewModelable
extension FeedViewModel: FeedViewModelable {
  func transform(_ input: Input) -> Output {
    bind()
    return Publishers
      .MergeMany([
        appearChains(input),
        didTapNotificationChains(input),
        didTapPostSearch(input),
        updateNotificationRedIconChains(),
        didTapReviewWrite(input)])
      .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FeedViewModel {
  func bind() {
    /// 알림이 올 경우 isNotificationArrived 값을 true로 해야 합니다.
    $isNotificationArrived.sink { [weak self] value in
      // 만약 notificationArrived가 true인 경우에 한 해서만 output 신호를 보냅니다.
      if value {
        self?.updateNotificatinoRedIcon.send()
      }
    }.store(in: &subscriptions)
  }
  
}

// MARK: - Transform stream private helpers
private extension FeedViewModel {
  func updateNotificationRedIconChains() -> Output {
    /// 알림이 왔다면 notificationArrived 값을 true로 하고, 이 함수가 호출될 것입니다.
    updateNotificatinoRedIcon
      .map { [weak self] _ -> State in
        self?.isNotificationArrived = false
        return .updateNotificationRedIcon
      }.eraseToAnyPublisher()
  }
  
  func appearChains(_ input: Input) -> Output {
    return input
      .appear
      .receive(on: backgroundQueue)
      .map { _ -> State in
        /// 이곳에서 영구저장소에 사용자가 알림을 확인했는지 확인해야합니다.
        /// 임시적으로 지금은 뷰가 나타났을 때 알림이 왔다는 가정을 했습니다. .none으로 할 경우 redIcon 사라집니다.
        return .viewAppear(userNotificationState: .notChecked)
      }.eraseToAnyPublisher()
  }
  
  func didTapNotificationChains(_ input: Input) -> Output {
    return input
      .didTapNotification
      .receive(on: backgroundQueue)
      .map { _ -> State in
        /// 이곳에서 영구저장소에 사용자가 알림을 확인했는지 확인해야 합니다.
        /// 그리고 확인된 값을 반환해야 합니다.
        /// 지금은 임시적으로 일관된 값을 반환합니다.
        return .goToNotification
      }.eraseToAnyPublisher()
  }
  
  func didTapPostSearch(_ input: Input) -> Output {
    return input
      .didTapPostSearch
      .receive(on: backgroundQueue)
      .map { _ -> State in
        return .goToPostSearch
      }.eraseToAnyPublisher()
  }
  
  func didTapReviewWrite(_ input: Input) -> Output {
    return input
      .didTapReviewWrite
      .receive(on: backgroundQueue)
      .map { _ -> State in
        return .gotoReviewWrite
      }.eraseToAnyPublisher()
  }
}
