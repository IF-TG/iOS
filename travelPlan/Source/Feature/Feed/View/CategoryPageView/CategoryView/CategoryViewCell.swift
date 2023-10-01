//
//  CategoryViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class CategoryViewCell: UICollectionViewCell {
  struct Model {
    let cagtegoryTitle: String
    let imagePath: String
  }
  
  // MARK: - Constant
  static var id: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  private let categoryImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray.withAlphaComponent(0.6)
    $0.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    $0.clipsToBounds = true
  }
  
  private let categoryTitle = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.systemFont(
      ofSize: Constant.Title.fontSize)
    $0.textAlignment = .center
    $0.textColor = Constant.Title.textColor
    $0.text = "카테고리"
  }
  
  override var isSelected: Bool {
    willSet {
      self.categoryTitle.textColor = newValue ? .black : Constant.Title.textColor
      // TODO: - 실제 이미지 뷰의 색 변화를 해야합니다.
      self.categoryImageView.backgroundColor = newValue ? .lightGray : .lightGray.withAlphaComponent(0.6)
      if newValue {
        selectedAnimation()
      } else {
        deselectedAnimation()
      }
    }
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    isSelected = false
    categoryImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    configure(with: nil)
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Helpers
extension CategoryViewCell {
  func configure(
    with data: Model?
  ) {
    categoryTitle.text = data?.cagtegoryTitle
    guard let imagePath = data?.imagePath else {
      categoryImageView.image = UIImage()
      return
    }
    categoryImageView.image = UIImage(named: imagePath)
  }
  
  func deselectedAnimation() {
    UIView.animate(withDuration: 0.3) {
      self.categoryImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
  }
  
  func selectedAnimation() {
    UIView.animate(withDuration: 0.3) {
      self.categoryImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
  }
}

// MARK: - LayoutSupport
extension CategoryViewCell: LayoutSupport {
  func addSubviews() {
    _=[categoryImageView, categoryTitle]
      .map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    _=[categoryImageViewConstraint, categoryTitleConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport constraints
private extension CategoryViewCell {
  var categoryImageViewConstraint: [NSLayoutConstraint] {
    [categoryImageView.topAnchor.constraint(
      equalTo: contentView.topAnchor,
      constant: Constant.ImageView.Spacing.top),
     categoryImageView.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor,
      constant: Constant.ImageView.Spacing.left),
     categoryImageView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -Constant.ImageView.Spacing.left),
     categoryImageView.heightAnchor.constraint(
      equalToConstant: Constant.ImageView.size.height)]
  }
  
  var categoryTitleConstraint: [NSLayoutConstraint] {
    [categoryTitle.topAnchor.constraint(
      equalTo: categoryImageView.bottomAnchor,
      constant: Constant.Title.Spacing.top),
     categoryTitle.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor),
     categoryTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
     categoryTitle.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor,
      constant: Constant.Title.Spacing.bottom)]
  }
}
