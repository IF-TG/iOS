//
//  PostHeaderContentView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/26.
//

import UIKit

final class PostHeaderContentView: UIView {
  enum Constant {
    enum Title {
      static let textColor: UIColor = .yg.gray7
      static let font: UIFont = UIFont(pretendard: .semiBold_600(fontSize: 18))!
      enum Spacing {
        static let leading: CGFloat = 10
        static let top: CGFloat = 3
      }
    }
    
    enum BottomView {
      enum Spacing {
        static let leading: CGFloat = 10
        static let top: CGFloat = 5
        static let bottom: CGFloat = 5
      }
    }
  }
  
  // MARK: - Properties
  private let title = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .left
    $0.font = Constant.Title.font
    $0.textColor = Constant.Title.textColor
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  private let bottomView = PostHeaderContentBottomView()
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Helpers
extension PostHeaderContentView {
  func configure(with data: PostHeaderContentInfo?) {
    setTitle(with: data?.title)
    setBottomView(with: data?.bottomViewInfo)
  }
}

// MARK: - Private helpers
extension PostHeaderContentView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  private func setTitle(with text: String?) {
    title.text = text
  }
  
  private func setBottomView(with subInfoData: PostHeaderContentBottomInfo?) {
    bottomView.configure(with: subInfoData)
  }
}

// MARK: - LayoutSupport
extension PostHeaderContentView: LayoutSupport {
  func addSubviews() {
    _=[
      title,
      bottomView
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      titleConstraints,
      subInfoViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - Private layoutSupport
private extension PostHeaderContentView {
  var titleConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.Title.Spacing
    return [
      title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Inset.leading),
      title.trailingAnchor.constraint(equalTo: trailingAnchor),
      title.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top)
    ]
  }
  
  var subInfoViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constant.BottomView.Spacing
    return [
      bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Inset.leading),
      bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Inset.top),
      bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Inset.bottom)
    ]
  }
}
