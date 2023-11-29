//
//  CustomerServiceViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit

final class CustomerServiceViewController: BaseSettingViewController {
  
  // MARK: - Properties
  private lazy var mailServiceView = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 24, height: 24), iconPath: "mail-icon"),
    countInfo: .init(fontType: .medium_500(fontSize: 16), lineHeight: 30)
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = 16
    $0.setCountLabel(text: "메일 문의")
  }
  
  private let contentView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 10
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
  }
}

extension CustomerServiceViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(contentView)
    contentView.addSubview(mailServiceView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      mailServiceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      mailServiceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      mailServiceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      mailServiceView.heightAnchor.constraint(equalToConstant: 52),
    
      contentView.leadingAnchor.constraint(equalTo: mailServiceView.leadingAnchor, constant: 20),
      contentView.centerYAnchor.constraint(equalTo: mailServiceView.centerYAnchor)])
  }
}
