//
//  PostDetailCategoryHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import UIKit

final class PostDetailCategoryHeaderView: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailCategoryHeaderView.self)
  
  // MARK: - Properties
  private let categoryLabel = BasePaddingLabel(
    padding: .init(top: 16.5, left: 20, bottom: 8.5, right: 20),
    fontType: .medium_500(fontSize: 14),
    lineHeight: 16.71
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.textColor = .yg.gray4
  }
  
  weak var delegate: PostDetailCategoryHeaderViewDelegate?
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
}

// MARK: - Helpers
extension PostDetailCategoryHeaderView {
  func configure(with text: String?) {
    categoryLabel.text = text
  }
}

// MARK: - Private Helpers
private extension PostDetailCategoryHeaderView {
  func configureUI() {
    setupUI()
    setTapGestureInCategoryLabel()
  }
  
  func setTapGestureInCategoryLabel() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCategoryLabel))
    categoryLabel.isUserInteractionEnabled = false
    categoryLabel.addGestureRecognizer(tap)
  }
}

// MARK: - Actions
private extension PostDetailCategoryHeaderView {
  @objc func didTapCategoryLabel(_ sender: UITapGestureRecognizer) {
    delegate?.didTapCategoryHeaderView(sender)
  }
}

// MARK: - LayoutSupport
extension PostDetailCategoryHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(categoryLabel)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      categoryLabel.topAnchor.constraint(equalTo: topAnchor),
      categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
  }
}
