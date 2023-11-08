//
//  PostDetailContentFooterView.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailContentFooterView: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailContentFooterView.self)
  
  enum Constant {
    static let DividerHeight: CGFloat = 1
    static let spacing: CGFloat = 10
  }
  
  // MARK: - Properties
  private let lineDivider = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.gray0
  }
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .white
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - LayoutSupport
extension PostDetailContentFooterView: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(lineDivider)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      lineDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.spacing),
      lineDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.spacing),
      lineDivider.heightAnchor.constraint(equalToConstant: Constant.DividerHeight),
      lineDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}
