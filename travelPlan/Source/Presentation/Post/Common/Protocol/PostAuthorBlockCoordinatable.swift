//
//  PostAuthorBlockCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/19/24.
//

import UIKit
import SHCoordinator

/// 포스트에서 특정 사용자를 차단할 때 화면전환을 제어할 수 있는 protocol입니다.
protocol PostAuthorBlockCoordinatable {
  func showPostAuthorBlock(_ authorName: String, handler: ((Bool) -> Void)?)
}

extension PostAuthorBlockCoordinatable where Self: FlowCoordinator, Self: AlertCoordinatable {
  func showPostAuthorBlock(_ authorName: String, handler: ((Bool) -> Void)?) {
    let alert = UIAlertController(
      title: "‘\(authorName)’님을 차단하시겠습니까?",
      message: "이 유저의 모든 게시물이 보이지 않고\n회원님에게 좋아요, 댓글을 남길 수 없으며\n팔로우가 취소됩니다.",
      preferredStyle: .alert
    ).set {
      $0.addAction(title: "취소", style: .cancel) { _ in handler?(false) }
      $0.addAction(title: "차단", style: .destructive) { _ in handler?(true) }
    }
    presenter?.present(alert, animated: true)
  }
}
