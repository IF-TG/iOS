//
//  CategoryViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class CategoryViewCell: UICollectionViewCell {
  enum Constant {
    enum ImageView {
      enum Spacing {
        static let top: CGFloat = 20
        static let left: CGFloat = 27.5
      }
      static let size: CGSize = CGSize(width: 28, height: 28)
    }
    enum Title {
      enum Spacing {
        static let top: CGFloat = 5
        static let bottom: CGFloat = 6
      }
      static let fontSize: CGFloat = 12
      static let height: CGFloat = 22
      static let textColor = UIColor(red: 0.404, green: 0.404, blue: 0.404, alpha: 1)
    }
    static let size: CGSize = {
      let width = Constant.ImageView.Spacing
        .left * 2.0 + ImageView.size.width
      let height = Constant.ImageView.Spacing.top +
      Constant.ImageView.size.height +
      Constant.Title.Spacing.top +
      Constant.Title.height +
      Constant.Title.Spacing.bottom
      return CGSize(width: width, height: height)
    }()
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
    $0.backgroundColor = .lightGray.withAlphaComponent(0.6)
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
private extension CategoryViewCell {
  var categoryImageViewConstraint: [NSLayoutConstraint] {
    typealias Const = Constant.ImageView
    typealias Spacing = Const.Spacing
    return [
      categoryImageView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      categoryImageView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: Spacing.left),
      categoryImageView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Spacing.left),
      categoryImageView.heightAnchor.constraint(
        equalToConstant: Const.size.height)]
  }
  
  var categoryTitleConstraint: [NSLayoutConstraint] {
    typealias Spacing = Constant.Title.Spacing
    return [
      categoryTitle.topAnchor.constraint(
        equalTo: categoryImageView.bottomAnchor,
        constant: Spacing.top),
      categoryTitle.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor),
      categoryTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      categoryTitle.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: Spacing.bottom)]
  }
}
