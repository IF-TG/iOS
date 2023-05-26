//
//  CautionAlertViewControllerDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/26.
//

import UIKit.UIViewController

enum CautionAlertType {
  case onlyConfirm /// 확인
  case withCancel /// 취소 + 확인
}

/// delegate pattern으로, alertButton(cancel, confirm)이 눌렸을 때 로직을 구현합니다.
@objc
protocol CautionAlertViewControllerDelegate: AnyObject {
  func didTapAlertConfirm()
  @objc optional func didTapAlertCancel()
}

/// in VC: CautionAlertViewControllerDelegate를 준수하고, showAlert를 호출하면 됩니다.
extension CautionAlertViewControllerDelegate where Self: UIViewController {
  func showAlert(
    alertType: CautionAlertType,
    message: String,
    cancelButtonText: String = "취소",
    confirmButtonText: String = "확인",
    target: CautionAlertViewControllerDelegate
  ) {
    let alertVC = CautionAlertViewController()
    alertVC.modalPresentationStyle = .overFullScreen
    alertVC.modalTransitionStyle = .crossDissolve
    
    alertVC.delegate = target
    alertVC.alertType = alertType
    alertVC.messageLabel.text = message
    
    alertVC.cancelButton.setTitle(cancelButtonText, for: .normal)
    alertVC.confirmButton.setTitle(confirmButtonText, for: .normal)
    
    present(alertVC, animated: true)
  }
}

// CautionAlertViewControllerDelegate를 준수한 UIViewController를 상속한 타입은 self.showAlert 메소드를 제공 받습니다.
  // where Self: UIViewController 조건을 추가했기 때문입니다.
