//
//  PostDetailFetchForUniversalLinkNotifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/18/24.
//

import Combine
import Foundation

/// 유니버셜 링크에 의해 포스트 상세 화면이 보여질 경우, postDetailVM에서 specific postInfo를 fetch하게 됩니다.
/// 이에 대해 특정 정보들을 notify하는데 이 protocol을 통해 어디에서든 쉽게 notify 받을 수 있습니다.
protocol PostDetailFetchForUniversalLinkNotifiable {
  var fetchedPostDetailNotifier: PassthroughSubject<FetchedPostDetailForUniversalLinkEntity, Never> { get }
  
  func makeFetchedPostDetailNotificationSubscriber() -> AnyCancellable
}

extension PostDetailFetchForUniversalLinkNotifiable where Self: AnyObject {
  func makeFetchedPostDetailNotificationSubscriber() -> AnyCancellable {
    return NotificationCenter
      .default
      .publisher(for: .fetchedPostDetailForUniversalLink)
      .sink { [weak self] notification in
        if let userInfo = notification.userInfo,
           let fetchedPostDetailForUniversalLink = userInfo[
            "fetchedPostDetailForUniversalLink"] as? FetchedPostDetailForUniversalLinkEntity {
          self?.fetchedPostDetailNotifier.send(fetchedPostDetailForUniversalLink)
        }
      }
  }
}
