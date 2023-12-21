//
//  BasePostView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

protocol PostCellEdgeDividable: AnyObject {
  func hideCellDivider()
}

final class BasePostView: UIView {
  // MARK: - Properties
  private let headerView = PostHeaderView()
  
  private lazy var optionButton = makeOptionButton()
  
  private var thumbnailView: UIView
  
  private let reviewLabel = BaseLabel(fontType: .regular_400(fontSize: 14)).set {
    $0.numberOfLines = 3
  }
  
  private let footerView = PostFooterView()
  
  private let line = OneUnitHeightLine(color: .yg.gray0)
  
  weak var delegate: BasePostViewDelegate?
  
  // MARK: - Lifecycle
  init(frame: CGRect, thumbnailView: UIView) {
    self.thumbnailView = thumbnailView
    super.init(frame: frame)
    configureUI()
    footerView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  func configure(with post: PostInfo?) {
    headerView.configure(with: post?.header)
    setReviewLabel(with: post?.content.text)
    footerView.configure(with: post?.footer)
    setCellDivieder(post == nil)
  }
}

// MARK: - Helpers
extension BasePostView {
  func hideCellDivider() {
    line.isHidden = true
  }
  
  func showCellDivider() {
    line.isHidden = false
  }
}

// MARK: - Private helpers
extension BasePostView {
  private func setCellDivieder(_ isVisible: Bool) {
    guard isVisible else {
      showCellDivider()
      return
    }
    hideCellDivider()
  }
  
  func setReviewLabel(with content: String?) {
    reviewLabel.text = content
    if content == nil { return }
    reviewLabel.sizeToFit()
  }
  
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.backgroundColor = UIColor.yg.littleWhite.cgColor
    layer.cornerRadius = 8
    thumbnailView.layer.cornerRadius = 10
    thumbnailView.clipsToBounds = true
    thumbnailView.translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    line.setConstraint(
      fromSuperView: self,
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
extension BasePostView {
  @objc func didTapOption() {
    delegate?.didTapOptionButton()
  }
}

// MARK: - PostFooterViewDelegate
extension BasePostView: PostFooterViewDelegate {
  func didTapHeart() {
    delegate?.didTapHeart()
  }
  
  func didTapComment() {
    delegate?.didTapComment()
  }
  
  func didTapShare() {
    delegate?.didTapShare()
  }
}

// MARK: - LayoutSupport
extension BasePostView: LayoutSupport {
  func addSubviews() {
    [
      headerView,
      thumbnailView,
      reviewLabel,
      footerView,
      optionButton
    ].forEach {
      addSubview($0)
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
private extension BasePostView {
  var headViewConstraints: [NSLayoutConstraint] {
    [headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
     headerView.topAnchor.constraint(equalTo: topAnchor, constant: 8.5),
     headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -65),
     headerView.heightAnchor.constraint(equalToConstant: 43)]
  }
  
  var thumbnailViewConstraints: [NSLayoutConstraint] {
    [thumbnailView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
     thumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
     thumbnailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11)]
  }
  
  var reviewLabelConstraints: [NSLayoutConstraint] {
    [reviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
     reviewLabel.topAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 8),
     reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11)]
  }

  var footerViewConstraints: [NSLayoutConstraint] {
    [footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
     footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
     footerView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 11),
     footerView.heightAnchor.constraint(equalToConstant: 20),
     footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)]
  }
  
  var optionButtonConstraints: [NSLayoutConstraint] {
    [optionButton.widthAnchor.constraint(equalToConstant: 20),
     optionButton.heightAnchor.constraint(equalToConstant: 20),
     optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
     optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)]
  }
}
