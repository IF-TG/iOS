//
//  CautionAlertViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/25.
//

import UIKit
import SnapKit

class CautionAlertViewController: UIViewController {
  enum AlertType {
    case onlyConfirm
    case withCancel
  }
  
  // MARK: - Properties
  private let messageLabel: UILabel = UILabel().set {
    $0.font = UIFont(SFPro: .sfPro, size: 13)
    $0.textColor = .black
    $0.text = "최근 검색 내역을\n모두 삭제하시겠습니까?"
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  
  private let alertView: UIView = UIView().set {
    $0.layer.cornerRadius = 14
    $0.backgroundColor = UIColor(hex: "#F2F2F2")
  }
  
  private let cancelButton: UIButton = UIButton().set {
    $0.setTitle("취소", for: .normal)
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.titleLabel?.font = UIFont(SFPro: .sfPro, size: 17)

  }
  
  private let confirmButton: UIButton = UIButton().set {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.titleLabel?.font = UIFont(SFPro: .sfPro, size: 17)
  }
  
  private lazy var buttonsStackView: UIStackView = UIStackView().set {
    $0.spacing = 0
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
//    $0.layer.borderColor = .cgColor
//    $0.layer.borderWidth = 0.5
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green
    setupUI()
  }
  
  deinit {
    print("deinit alertController")
  }
}

extension CautionAlertViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(alertView)
    alertView.addSubview(messageLabel)
    alertView.addSubview(buttonsStackView)
    
    [cancelButton, confirmButton].map {
      buttonsStackView.addArrangedSubview($0)
    }
  }
  
  func setConstraints() {
    alertView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(275)
    }
    
    messageLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.centerX.equalToSuperview()
    }
    
    buttonsStackView.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom).offset(16)
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(44)
    }
  }
}

// MARK: - Helpers
extension CautionAlertViewController {

}

// MARK: - Public Helpers
extension CautionAlertViewController {
}

extension CALayer {
  func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
    for edge in arr_edge {
      let border = CALayer()
      switch edge {
      case .top:
        border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
      case .bottom:
        border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
      case .left:
        border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
      case .right:
        border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
      default: break
      }
      border.backgroundColor = color.cgColor
      self.addSublayer(border)
    }
  }
}
