//
//  AlertCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/9/24.
//

import UIKit
import SHCoordinator

protocol AlertCoordinatable {}

extension AlertCoordinatable where Self: FlowCoordinator {
  /// 에러가 발생됬을때 에러 문구를 사용자에게 보여주는 기본 알림창입니다.
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(title: "OK", style: .default) { _ in completion?() }
    }
    presenter?.present(alert, animated: true)
  }
  
  /// 예, 아니요를 클릭할 수 있는 알림창이 보여집니다.
  /// 예를 누를 경우 true가 아니요를 누를 경우 false가 completion으로 반환됩니다.
  func showAlertWithYesNo(with title: String?, message: String?, completion: ((Bool) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert).set {
      $0.addAction(title: "아니요", style: .cancel) { _ in completion?(false) }
      $0.addAction(title: "예", style: .default) { _ in completion?(true) }
    }
    presenter?.present(alert, animated: true)
  }
}
