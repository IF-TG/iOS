//
//  PostViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

protocol BasePostCellThumbnailConfigurable: AnyObject {
  func setThumbnail(with images: [String]?)
}

class BasePostCell: UICollectionViewCell {
  static let id = String(describing: BasePostCell.self)
  
  // MARK: - Properties
  private let headerView = PostHeaderView()
  
  private lazy var optionButton = makeOptionButton()
  
  private var thumbnailView: UIView & BasePostCellThumbnailConfigurable
  
  private let reviewLabel = BaseLabel(fontType: .regular_400(fontSize: 14)).set {
    $0.numberOfLines = 3
  }
  
  private let footerView = PostFooterView()
  
  private let line = OneUnitHeightLine(color: .yg.gray0)
  
  // MARK: - Lifecycle
  init(frame: CGRect, thumbnailView: UIView & BasePostCellThumbnailConfigurable) {
    self.thumbnailView = thumbnailView
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
    hideCellDivider()
  }
}

// MARK: - Helpers
extension BasePostCell {
  func configure(with post: PostInfo?) {
    headerView.configure(with: post?.header)
    thumbnailView.setThumbnail(with: post?.content.thumbnailURLs)
    setReviewLabel(with: post?.content.text)
    footerView.configure(with: post?.footer)
    setCellDivieder(post == nil)
  }
  
  func hideCellDivider() {
    line.isHidden = true
  }
  
  func showCellDivider() {
    line.isHidden = false
  }
}

// MARK: - Private helpers
extension BasePostCell {
  private func setCellDivieder(_ isVisible: Bool) {
    guard isVisible else {
      showCellDivider()
      return
    }
    hideCellDivider()
  }
  
  func setReviewLabel(with content: String?) {
    reviewLabel.text = content
    guard let content else { return }
    reviewLabel.sizeToFit()
  }
  
  private func configureUI() {
    setupUI()
    line.setConstraint(
      fromSuperView: contentView,
      spacing: .init(leading: 11, trailing: 11))
  }
  
  private func makeOptionButton() -> UIButton {
    return UIButton().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.setImage(UIImage(named: "feedOption"), for: .normal)
      $0.setImage(UIImage(named: "feedOption")?.setColor(.yg.gray4.withAlphaComponent(0.5)), for: .highlighted)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
      $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
    }
  }
}

// MARK: - Action
extension BasePostCell {
  @objc func didTapOption() {
    print("DEBUG: pop up option scene !!")
    UIView.touchAnimate(optionButton)
  }
}

// MARK: - LayoutSupport
extension BasePostCell: LayoutSupport {
  func addSubviews() {
    [
      headerView,
      thumbnailView,
      reviewLabel,
      footerView,
      optionButton
    ].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    [
      headViewConstraints,
      thumbnailViewConstraints,
      reviewLabelConstraints,
      footerViewConstraints,
      optionButtonConstraints
    ].forEach {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - Private layoutsupport
private extension BasePostCell {
  var headViewConstraints: [NSLayoutConstraint] {
    [headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
     headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.5),
     headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -65),
     headerView.heightAnchor.constraint(equalToConstant: 43)]
  }
  
  var thumbnailViewConstraints: [NSLayoutConstraint] {
    [thumbnailView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
     thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
     thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
     thumbnailView.heightAnchor.constraint(equalToConstant: 118)]
  }
  
  var reviewLabelConstraints: [NSLayoutConstraint] {
    [reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
     reviewLabel.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 8),
     reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11)]
  }

  var footerViewConstraints: [NSLayoutConstraint] {
    return [
      footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      footerView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 11),
      footerView.heightAnchor.constraint(equalToConstant: 20),
      footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)]
  }
  
  var optionButtonConstraints: [NSLayoutConstraint] {
    [optionButton.widthAnchor.constraint(equalToConstant: 20),
     optionButton.heightAnchor.constraint(equalToConstant: 20),
     optionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
     optionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)]
  }
}
