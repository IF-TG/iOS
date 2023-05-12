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
  let content = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CategoryDetailViewCell {
  func configCell(with indexPath: IndexPath) -> UICollectionViewCell {
    backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    return self
  }
}

// MARK: - LayoutSupport
extension CategoryDetailViewCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(content)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(contentConstraint)
  }
}

fileprivate extension CategoryDetailViewCell {
  var contentConstraint: [NSLayoutConstraint] {
    [content.topAnchor.constraint(
      equalTo: contentView.topAnchor,
      constant: Constant.Spacing.top),
     content.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor),
     content.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor),
     content.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor)]
  }
}
