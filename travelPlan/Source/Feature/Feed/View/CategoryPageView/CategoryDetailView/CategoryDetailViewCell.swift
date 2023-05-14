//
//  CategoryDetailViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

class CategoryDetailViewCell: UICollectionViewCell {
  // MARK: - Constant
  static var id: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  private var postView: PostView!
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public helpers
extension CategoryDetailViewCell {
  func configure(with data: [PostModel]
  ) -> UICollectionViewCell {
    setPostView(with: data)
    return self
  }
}

// MARK: - Helpers
extension CategoryDetailViewCell {
  private func setPostView(with data: [PostModel]) {
    if postView == nil {
      postView = PostView(
        with: PostViewModel(data: data))
      setupUI()
    }
  }
}

// MARK: - LayoutSupport
extension CategoryDetailViewCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(postView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      postView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Constant.Spacing.top),
      postView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor),
      postView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      postView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor)])
  }
}
