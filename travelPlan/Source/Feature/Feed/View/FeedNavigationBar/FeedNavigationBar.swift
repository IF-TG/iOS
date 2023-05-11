//
//  FeedNavigationBar.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/10.
//

import UIKit
import Combine

final class FeedNavigationBar: UIView {
  // MARK: - Properties
  var delegate: FeedNavigationBarDelegate?
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let appTitle: UILabel = UILabel().set {
    let text = Constant.Title.text
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = Constant.Title.textColor
    $0.font = UIFont(
      name: "SFProText-Semibold",
      size: Constant.Title.fontSize)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.02
    $0.attributedText = NSMutableAttributedString(
      string: text,
      attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle])
  }
  
  private let userPostSearchButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "search")
    $0.setImage(image?.setColor(Constant.UserPostSearch.normalColor), for: .normal)
    $0.setImage(image?.setColor(Constant.UserPostSearch.highlightColor), for: .highlighted)
  }
  
  private let notificationButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "notification")
    $0.setImage(image?.setColor(UIColor(hex: "#484848")), for: .normal)
    $0.setImage(image?.setColor(UIColor(hex: "#484848").withAlphaComponent(0.5)), for: .highlighted)
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    backgroundColor = .white
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  deinit {
    _=subscriptions.map { $0.cancel() }
  }
}

// MARK: - Helper
extension FeedNavigationBar {
  
  private func bind() {
    userPostSearchButton.tap.sink {
      self.delegate?.didTapUserPostSearch()
    }.store(in: &subscriptions)
    notificationButton.tap.sink {
      self.delegate?.didTapNotification()
    }.store(in: &subscriptions)
  }
  
  func layoutFrom(_ navigationBar: UINavigationBar) {
    let navi = navigationBar
    navi.addSubview(self)
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: navi.topAnchor),
      leadingAnchor.constraint(equalTo: navi.leadingAnchor),
      trailingAnchor.constraint(equalTo: navi.trailingAnchor),
      bottomAnchor.constraint(equalTo: navi.bottomAnchor)])
  }
}

// MARK: - LayoutSupport
extension FeedNavigationBar: LayoutSupport {
  func addSubviews() {
    _=[appTitle, userPostSearchButton, notificationButton]
      .map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[appTitleConstraint,
       notificationButtonConstraint,
       userPostSearchButtonConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

fileprivate extension FeedNavigationBar {
  var appTitleConstraint: [NSLayoutConstraint] {
    [appTitle.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.Title.leadingSpacing),
     appTitle.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.Title.topSpacing),
     appTitle.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.Title.bottomSpacing)]
  }
  
  var userPostSearchButtonConstraint: [NSLayoutConstraint] {
    [userPostSearchButton.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.UserPostSearch.topSpacing),
     userPostSearchButton.trailingAnchor.constraint(
      equalTo: notificationButton.leadingAnchor,
      constant: -Constant.UserPostSearch.trailingSpacing),
     userPostSearchButton.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.UserPostSearch.bottomSpacing)]
  }
  
  var notificationButtonConstraint: [NSLayoutConstraint] {
    [notificationButton.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.Notification.topSpacaing),
     notificationButton.trailingAnchor.constraint(
      equalTo: trailingAnchor,
     constant: -Constant.Notification.trailingSpacing),
     notificationButton.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.Notification.bottomSpacing)]
  }
}
