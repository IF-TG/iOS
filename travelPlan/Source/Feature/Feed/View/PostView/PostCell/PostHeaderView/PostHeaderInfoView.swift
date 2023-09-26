//
//  PostHeaderInfoView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/26.
//

import UIKit

final class PostHeaderInfoView: UIView {
  enum Constants {
    enum Title {
      static let textColor: UIColor = .yg.gray7
      static let font: UIFont = UIFont(pretendard: .semiBold, size: 18)!
      enum Inset {
        static let top: CGFloat = 3
      }
    }
    
    enum subInfoView {
      enum Inset {
        static let top: CGFloat = 5
        static let bottom: CGFloat = 5
      }
    }
  }
  
  // MARK: - Properties
  private let title = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .left
    $0.font = Constants.Title.font
    $0.textColor = Constants.Title.textColor
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  private let subInfoView = PostHeaderSubInfoView()
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  // MARK: - Helper
  func configure(title: String?, subInfoData: PostHeaderSubInfoModel) {
    setTitle(with: title)
    setSubInfo(with: subInfoData)
  }
  
  // MARK: - Private helper
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  private func setTitle(with text: String?) {
    title.text = text
  }
  
  private func setSubInfo(with subInfoData: PostHeaderSubInfoModel?) {
    subInfoView.configure(with: subInfoData)
  }
}
// MARK: - LayoutSupportable
extension PostHeaderInfoView: LayoutSupport {
  func addSubviews() {
    _=[
      title,
      subInfoView
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

// MARK: - Private layoutSupportable
private extension PostHeaderInfoView {
  var titleConstraints: [NSLayoutConstraint] {
    typealias Inset = Constants.Title.Inset
    return [
      title.leadingAnchor.constraint(equalTo: leadingAnchor),
      title.trailingAnchor.constraint(equalTo: trailingAnchor),
      title.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
    ]
  }
  
  var subInfoViewConstraints: [NSLayoutConstraint] {
    typealias Inset = Constants.subInfoView.Inset
    return [
      subInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
      subInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
      subInfoView.topAnchor.constraint(equalTo: topAnchor, constant: Inset.top),
      subInfoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Inset.bottom)
    ]
  }
}
