//
//  PostContentAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostContentAreaView: UIView {
  enum Constant {
    static var maximumHeight: CGFloat {
      Thumbnail.height 
      + Thumbnail.Spacing.top
      + Text.maximumHeight
    }
    static var minimumHeight: CGFloat {
      Thumbnail.height
      + Thumbnail.Spacing.top
      + Text.minimumHeight
    }
    enum Thumbnail {
      static let height: CGFloat = 118
      enum Spacing {
        static let leading: CGFloat = 11
        static let trailing = leading
        static let top: CGFloat = 8
      }
    }
    enum Text {
      static var minimumHeight: CGFloat {
        font.lineHeight + Spacing.top + Spacing.bottom + 4
      }
      static var maximumHeight: CGFloat {
        maximumLineHeight + Spacing.top + Spacing.bottom + 4
      }
      static let textSize: CGFloat = 14
      static let lineBreakMode: NSLineBreakMode = .byWordWrapping
      static let font: UIFont = UIFont(pretendard: .regular, size: 14)!
      static var maximumLineHeight: CGFloat { font.lineHeight * 3 }
      enum Spacing {
        static let top: CGFloat = 8
        static let bottom: CGFloat = 5
        static let leading: CGFloat = 11
        static let trailing: CGFloat = 11
      }
    }
  }
  
  // MARK: - Properties
  private var thumbnail: PostThumbnailView = PostThumbnailView()
  
  private let text = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 0
    $0.font = Constant.Text.font
    $0.lineBreakMode = Constant.Text.lineBreakMode
    $0.sizeToFit()
  }
  
  // MARK: - Lifecycle
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
  func configure(with data: PostContentInfo?) {
    setText(with: data?.text)
    setThumbnail(with: data?.thumbnailImages)
  }
}

// MARK: - Helpers
private extension PostContentAreaView {
  func setText(with content: String?) {
    text.text = content
  }
  
  func setThumbnail(with images: [UIImage]?) {
    thumbnail.configure(with: images)
  }
}

// MARK: - LayoutSupport
extension PostContentAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      thumbnail,
      text
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      thumbnailConstraints,
      textConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport
private extension PostContentAreaView {
  var thumbnailConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.Thumbnail.Spacing
    typealias Const = Constant.Thumbnail
    return [
      thumbnail.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Spacing.top),
      thumbnail.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Spacing.leading),
      thumbnail.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Spacing.trailing),
      thumbnail.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var textConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.Text
    typealias Spacing = Constant.Text.Spacing
    return [
      text.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Spacing.leading),
      text.topAnchor.constraint(
        equalTo: thumbnail.bottomAnchor,
        constant: Spacing.top),
      text.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Spacing.trailing),
      text.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Spacing.bottom)]
  }
}
