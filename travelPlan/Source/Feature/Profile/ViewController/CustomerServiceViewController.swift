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
    countInfo: .init(fontType: .medium_500(fontSize: 16), lineHeight: nil)
  ).set {
    $0.setCountLabel(text: "메일 문의")
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = 16
    $0.distribution = .fillProportionally
    $0.alignment = .center
    $0.backgroundColor = .none
    
  }
  
  private let contentView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 10
    $0.backgroundColor = .white
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
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      contentView.heightAnchor.constraint(equalToConstant: 52),
    
      mailServiceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      mailServiceView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
  }
}
