//
//  CautionAlertViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/25.
//

import UIKit
import SnapKit

final class CautionAlertViewController: UIViewController {
  // MARK: - Properties
  var alertType: CautionAlertType?
  weak var delegate: CautionAlertViewControllerDelegate?
  
  let messageLabel: UILabel = UILabel().set {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = .black
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  private let alertView: UIView = UIView().set {
    $0.layer.cornerRadius = 14
    $0.backgroundColor = UIColor(hex: "#F2F2F2")
  }
  
  lazy var cancelButton: UIButton = UIButton().set {
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 17)
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  lazy var confirmButton: UIButton = UIButton().set {
    $0.setTitleColor(.systemBlue, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 17)
    $0.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
  }
  
  private lazy var buttonsStackView: UIStackView = UIStackView().set {
    $0.spacing = 0
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupCancelButton(by: alertType)
    view.backgroundColor = .black.withAlphaComponent(0.1)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupAlertBorderStyle()
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - Actions
extension CautionAlertViewController {
  @objc private func didTapCancelButton(_ button: UIButton) {
    dismiss(animated: true) {
      guard let didTapAlertCancel = self.delegate?.didTapAlertCancel else { return }
      didTapAlertCancel()
    }
  }
  
  @objc private func didTapConfirmButton(_ button: UIButton) {
    dismiss(animated: true) {
      guard let didTapAlertConfirm = self.delegate?.didTapAlertConfirm else { return }
      didTapAlertConfirm()
    }
  }
}
// MARK: - Helpers
extension CautionAlertViewController {
  private func setupCancelButton(by alertType: CautionAlertType?) {
    switch alertType {
    case .onlyConfirm:
      cancelButton.isHidden = true
    case .withCancel, .none: break
    }
  }
  
  private func setupAlertBorderStyle() {
    buttonsStackView.layer.addBorder(
      at: [.top],
      color: UIColor(hex: "#3C3C43").withAlphaComponent(0.36),
      width: 0.5
    )
    cancelButton.layer.addBorder(
      at: [.right],
      color: UIColor(hex: "#3C3C43").withAlphaComponent(0.36),
      width: 0.5
    )
  }
}

// MARK: - LayoutSupport
extension CautionAlertViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(alertView)
    
    alertView.addSubview(messageLabel)
    alertView.addSubview(buttonsStackView)
    
    _ = [cancelButton, confirmButton].map {
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
