//
//  ReviewWritingThemeSectionHeader.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit

final class ReviewWritingThemeSectionHeader: UICollectionReusableView {
  static let id = String(describing: ReviewWritingThemeSectionHeader.self)
  
  // MARK: - Properties
  private let title = BaseLabel.init(fontType: .semiBold_600(fontSize: 14)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) { nil }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
  
  // MARK: - Helpers
  func configure(with text: String?) {
    self.title.text = text
  }
}

// MARK: - LayoutSupport
extension ReviewWritingThemeSectionHeader: LayoutSupport {
  func addSubviews() {
    addSubview(title)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      title.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
      title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)])
  }
}
