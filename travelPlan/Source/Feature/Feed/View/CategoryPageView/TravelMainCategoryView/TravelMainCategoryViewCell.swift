//
//  TravelMainCategoryViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class TravelMainCategoryViewCell: UICollectionViewCell {
  enum Constant {
    enum ImageView {
      enum Spacing {
        static let top: CGFloat = 16
      }
      static let size: CGSize = CGSize(width: 28, height: 28)
    }
    enum Title {
      enum Spacing {
        static let top: CGFloat = 2
        static let bottom: CGFloat = 3
      }
      static let fontSize: CGFloat = 12
      static let height: CGFloat = 23
      static let textColor = UIColor.yg.gray3
    }
    static let size: CGSize = .init(width: 74, height: 72)
  }

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
    $0.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    $0.clipsToBounds = true
  }
  
  private let categoryTitle = UILabel().set {
    typealias Const = Constant.Title
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.systemFont(
      ofSize: Const.fontSize)
    $0.textAlignment = .center
    $0.textColor = Const.textColor
    $0.text = "카테고리"
  }
  
  override var isSelected: Bool {
    willSet {
      self.categoryTitle.textColor = newValue ? .black : Constant.Title.textColor
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

// MARK: - Helper
extension TravelMainCategoryViewCell {
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
    let convertedImage = categoryImageView.image?.withTintColor(.yg.gray2)
    UIView.animate(
      withDuration: 0.26,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.categoryImageView.image = convertedImage
      self.categoryImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
  }
  
  func selectedAnimation() {
    let convertedImage = categoryImageView.image?.withTintColor(.yg.primary)
    UIView.animate(
      withDuration: 0.26,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.categoryImageView.image = convertedImage
      self.categoryImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
  }
  
  // MARK: - Private helper
  
  private func convertImageColor(_ image: UIImage) -> UIImage {
    image.withTintColor(.yg.primary)
  }
}
// MARK: - LayoutSupport
extension TravelMainCategoryViewCell: LayoutSupport {
  func addSubviews() {
    _=[
      categoryImageView,
      categoryTitle
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      categoryImageViewConstraint,
      categoryTitleConstraint
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constraints
private extension TravelMainCategoryViewCell {
  var categoryImageViewConstraint: [NSLayoutConstraint] {
    typealias Const = Constant.ImageView
    typealias Spacing = Const.Spacing
    return [
      categoryImageView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      categoryImageView.widthAnchor.constraint(
        equalToConstant: Const.size.width),
      categoryImageView.centerXAnchor.constraint(
        equalTo: contentView.centerXAnchor),
      categoryImageView.heightAnchor.constraint(
        equalToConstant: Const.size.height)]
  }
  
  var categoryTitleConstraint: [NSLayoutConstraint] {
    typealias Const = Constant.Title
    typealias Spacing = Const.Spacing
    return [
      categoryTitle.topAnchor.constraint(
        equalTo: categoryImageView.bottomAnchor,
        constant: Spacing.top),
      categoryTitle.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor),
      categoryTitle.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      categoryTitle.heightAnchor.constraint(
        equalToConstant: Const.height),
      categoryTitle.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -Spacing.bottom)]
  }
}
