//
//  PostContentAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostContentAreaView: UIView {
  // MARK: - Properties
  private var thumbnail: PostThumbnailView = PostThumbnailView()
  
  private let text = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 3
    $0.text = " "
    $0.font = Constant.Text.font
    $0.lineBreakMode = Constant.Text.lineBreakMode
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public helpers
extension PostContentAreaView {
  func configure(with data: PostContentAreaModel) {
    setText(with: data.text)
    setThumbnail(with: data.thumbnailImages)
  }
}

// MARK: - Helpers
private extension PostContentAreaView {
  func setText(with content: String) {
    text.text = content
  }
  
  func setThumbnail(with images: [UIImage]) {
    thumbnail.configure(with: images)
  }
}

// MARK: - LayoutSupport
extension PostContentAreaView: LayoutSupport {
  func addSubviews() {
    _=[thumbnail, text].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[thumbnailConstraints, textConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport
private extension PostContentAreaView {
  var thumbnailConstraints: [NSLayoutConstraint] {
    [thumbnail.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.ImageSpacing.top),
      thumbnail.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.ImageSpacing.leading),
     thumbnail.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.ImageSpacing.trailing),
     thumbnail.heightAnchor.constraint(equalToConstant: Constant.imageHeight)]
  }
  
  var textConstraints: [NSLayoutConstraint] {
    [text.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.Text.Spacing.leading),
     text.topAnchor.constraint(
      equalTo: thumbnail.bottomAnchor,
      constant: Constant.Text.Spacing.top),
     text.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.Text.Spacing.trailing),
     text.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.Text.Spacing.bottom)]
  }
}
