//
//  FeedNavigationBarDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/10.
//

// 만약 네비에서 버튼 이벤트 발생했을 때 화면 전환을 위해서
// 이걸 상속받는 뷰 컨한테 델리 위임한다. 뷰컨은 특정 버튼이벤트에 따라 화면 전환
protocol FeedNavigationBarDelegate: AnyObject {
  func didTapPostSearch()
  func didTapNotification()
}
