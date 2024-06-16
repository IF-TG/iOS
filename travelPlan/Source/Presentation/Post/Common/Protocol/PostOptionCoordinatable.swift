//
//  PostOptionCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/9/24.
//

import UIKit
import SHCoordinator

protocol PostOptionCoordinatable { }

extension PostOptionCoordinatable where Self: FlowCoordinator, Self: AlertCoordinatable {
  func showOption(handler: ((PostOption) -> Void)?) {
    /// 액션시트에서 cancel은 하나밖에 안됩니다.
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    PostOption.allCases.forEach { option in
      alert.addAction(title: option.rawValue, style: .destructive) { _ in handler?(option) }
    }
    alert.addAction(title: "취소", style: .cancel, handler: nil)
    presenter?.present(alert, animated: true)
  }
  
  func showPostOptionForMine(completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(title: "공유하기", style: .default) { _ in completion?() }
    alert.addAction(title: "취소", style: .cancel, handler: nil)
    presenter?.present(alert, animated: true)
  }
  
  func showPostReport(handler: ((PostReportType) -> Void)?) {
    let alert = UIAlertController(title: "신고하기", message: nil, preferredStyle: .alert)
    PostReportType.allCases.forEach { report in
      var isStoppedRequest = false
      if report == .stopRequest { isStoppedRequest = true }
      alert.addAction(title: report.toKorean, style: isStoppedRequest ? .destructive : .default) { _ in
        handler?(report)
      }
    }
    presenter?.present(alert, animated: true, completion: nil)
  }
  
  func showPostReportResult(wtih option: PostOption) {
    switch option {
    case .postBlock:
      presenter?.present(PostOptionResultAlertController(type: .postAuthorBlock), animated: true)
    case .postReport:
      presenter?.present(PostOptionResultAlertController(type: .postReport), animated: true)
    }
  }
  
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
