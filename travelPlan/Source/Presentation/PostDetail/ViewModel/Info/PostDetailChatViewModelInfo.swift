//
//  PostDetailChatViewModelInfo.swift
//  travelPlan
//
//  Created by 양승현 on 6/21/24.
//

import Foundation

struct PostDetailChatViewModelInfo {
  let postId: PostIdentifier
  
  /// Flow1: 앱스플라이엉 디퍼드 딥 링크에 의해 접속될 경우
  /// - 사용자가 댓글, 대댓글 작성 및 제거할 때 post Footer info만 새로 개선해주고, 피드화면에서는 알려주지 않아도 됩니다.
  /// Flow2: 피드 화면에서 특정한 여행 후기 summary(thumbnail)를 클릭해 여행 후기 상세 화면으로 이동됬을 때
  /// - hasEnteredByDefferedDeepLink는 false이므로 이때 노티피케이션을 통해 상세화면 들어오기 이전 post thumbnail cell에서 대댓글 전체 개수를
  ///   증가 혹은 감소합니다.
  let hasEnteredByDeferredDeepLink = false
}
