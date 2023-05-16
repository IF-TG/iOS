//
//  FeedViewModelProtocols.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import Combine

// viewModel을 viewController에 바인딩 이후,
// 서버에서 알림이 오는지 3~5초마다TODO: - 확인 후 알림이 왔다면 feedVM의 notificationArrived 값을 true로 해야합니다.
enum FeedViewModelError: Error {
  case none
}

struct FeedViewControllerEvent {
  let appear: AnyPublisher<Void, FeedViewModelError>
  let didTapPostSearch: AnyPublisher<Void, FeedViewModelError>
  let didTapNotification: AnyPublisher<Void, FeedViewModelError>
}

enum FeedViewControllerState {
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
}
