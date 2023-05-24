//
//  FavoriteListHeaderImageView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteListHeaderImageViews: UIView {
  // MARK: - Properteis
  private let imageViews: [UIImageView] = (0...4).map { _ -> UIImageView in
    return UIImageView().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.layer.masksToBounds = true
      $0.contentMode = .scaleAspectFill
      $0.backgroundColor = Constant.ImageView.bgColor
    }
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = FavoriteListHeaderView
      .Constant
      .ImageViews
      .size.width / 2.0
    clipsToBounds = true
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension FavoriteListHeaderImageViews {
  func configure(with data: [UIImage?]) {
    for (i, image) in data.enumerated() {
      if i < 4 {
        self.imageViews[i].image = image
      } else {
        break
      }
    }
  }
}

// MARK: - LayoutSupport
extension FavoriteListHeaderImageViews: LayoutSupport {
  func addSubviews() {
    _=imageViews.map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[upperLeftIv, upperRightIv, lowerLeftIv, lowerRightIv]
      .map {
        NSLayoutConstraint.activate($0)
      }
  }
}

// MARK: - LayoutSupport constriants
private extension FavoriteListHeaderImageViews {
  var upperLeftIv: [NSLayoutConstraint] {
    let iv = imageViews[0]
    return [
      iv.leadingAnchor.constraint(equalTo: leadingAnchor),
      iv.topAnchor.constraint(equalTo: topAnchor),
      iv.widthAnchor.constraint(
        equalToConstant: Constant.ImageView.size.width),
      iv.heightAnchor.constraint(
        equalToConstant: Constant.ImageView.size.height)]
  }
  
  var upperRightIv: [NSLayoutConstraint] {
    let iv = imageViews[1]
    let upperLeftIv = imageViews[0]
    return [
      iv.leadingAnchor.constraint(
        equalTo: upperLeftIv.trailingAnchor,
        constant: Constant.itemSpacing),
      iv.topAnchor.constraint(equalTo: topAnchor),
      iv.trailingAnchor.constraint(equalTo: trailingAnchor),
      iv.heightAnchor.constraint(
        equalToConstant: Constant.ImageView.size.height)]
  }
  
  var lowerLeftIv: [NSLayoutConstraint] {
    let upperLeftIv = imageViews[0]
    let iv = imageViews[2]
    return [
      iv.leadingAnchor.constraint(equalTo: leadingAnchor),
      iv.topAnchor.constraint(
        equalTo: upperLeftIv.bottomAnchor,
        constant: Constant.lineSpacing),
      iv.widthAnchor.constraint(
        equalToConstant: Constant.ImageView.size.width),
      iv.heightAnchor.constraint(
        equalToConstant: Constant.ImageView.size.height)]
  }
  
  var lowerRightIv: [NSLayoutConstraint] {
    let iv = imageViews.last!
    let upperRightIv = imageViews[1]
    let lowerLeftIv = imageViews[2]
    return [
      iv.leadingAnchor.constraint(
        equalTo: lowerLeftIv.trailingAnchor,
        constant: Constant.itemSpacing),
      iv.topAnchor.constraint(
        equalTo: upperRightIv.bottomAnchor,
        constant: Constant.lineSpacing),
      iv.trailingAnchor.constraint(equalTo: trailingAnchor),
      iv.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}
