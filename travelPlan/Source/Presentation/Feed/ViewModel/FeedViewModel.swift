//
//  FeedViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import Combine
import Foundation

// notificationArrivedTODO: - NotificationIcon render
/// - 로그인한 사용자한테 오는 알림을 감지했다 알림이 오면 view 한테 상태 업데이트해야 합니다.
/// - 그 상태 변화는 Feed에 있을 때, 5초에한번씩 서버로부터 확인한다든지 등등..
/// 확인이 될 경우엔 notificationArrived 상태값을 true로 변경합니다.
/// - true로 변경됬을 때,
/// 영구저장소에는 isCheckedNotification을 false로 합니다.
/// 그리고 ui state를 updateNotificationRedIcon로 변경합니다.
final class FeedViewModel {
  struct Input {
    let appear: PassthroughSubject<Void, Never>
    let didTapPostSearch: AnyPublisher<Void, Never>
    let didTapNotification: AnyPublisher<Void, Never>
    let didTapReviewWrite: AnyPublisher<Void, Never>
    
    init(
      appear: PassthroughSubject<Void, Never> = .init(),
      didTapPostSearch: AnyPublisher<Void, Never>,
      didTapNotification: AnyPublisher<Void, Never>,
      didTapReviewWrite: AnyPublisher<Void, Never>
    ) {
      self.appear = appear
      self.didTapPostSearch = didTapPostSearch
      self.didTapNotification = didTapNotification
      self.didTapReviewWrite = didTapReviewWrite
    }
  }
  
  enum ErrorType: Error {
    case none
  }
  
  enum State {
    case none
    
    /// FeedViewControllerEvent에서 발생된 appear의 경우 이 case로 render 해야합니다.
    /// Feed vm에서는 최초로 사용자가 알림을 확인했었는지 여부를 영구 저장소에서 파악해야 합니다.
    /// 로그인 한 사용자게에 보낸 알림이 없는지 확인해야 합니다.
    case viewAppear(userNotificationState: UserNotificationState)
    
    /// NotificationViewController로 들어가게 된다면 영구저장소의 feed알림 확인 상태를 .none or true (확인했다)로 변경해야 합니다.
    case goToNotification
    case goToPostSearch
    
    /// 타인으로부터 알림이 발생될 경우 vm에서 1~5초간 서버로부터 감지하다 알림이 왔다고 icon 색을 빨간색으로 변경해야 합니다.
    /// 동시에 영구저장소도 feed에서 알림을 확인했는지 유무를 false(확인 안했다)로 업데이트 해야합니다.
    case updateNotificationRedIcon
    case gotoReviewWrite
  }
  
  // MARK: - Properteis
  @Published private var isNotificationArrived = false
  
  private var updateNotificatinoRedIcon = PassthroughSubject<Void, ErrorType>()
  var subscriptions = Set<AnyCancellable>()
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

// MARK: - Helpers
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

// MARK: - Operator chains
private extension FeedViewModel {
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
  
  func didTapReviewWrite(_ input: Input) -> Output {
    return input
      .didTapReviewWrite
      .subscribe(on: RunLoop.main)
      .tryMap { _ -> State in
        return .gotoReviewWrite
      }.mapError { $0 as? ErrorType ?? .none }
      .eraseToAnyPublisher()
  }
}
