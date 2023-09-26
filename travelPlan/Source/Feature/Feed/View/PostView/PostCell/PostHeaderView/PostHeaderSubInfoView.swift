//
//  PostHeaderSubInfoView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostHeaderSubInfoView: UIView {
  // MARK: - Properties
  private lazy var userNameLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = " "
    $0.textColor = Constant.UserName.textColor
    $0.textAlignment = .left
    $0.numberOfLines = 1
    $0.font = Constant.UserName.font
    $0.isUserInteractionEnabled = true
    let touch = UITapGestureRecognizer(target: self, action: #selector(didTapUserName))
    $0.addGestureRecognizer(touch)
  }
  
  private let durationLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = " "
    $0.textColor = Constant.Duration.textColor
    $0.textAlignment = .center
    $0.numberOfLines = 1
    $0.font = Constant.Duration.font
  }
  
  private let yearMonthDayRangeLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = " "
    $0.textColor = Constant.DateRange.textColor
    $0.textAlignment = .center
    $0.numberOfLines = 1
    $0.font = Constant.DateRange.font
  }
  
  private let dividerView: [UIView] = (0..<2).map { _ in
    return UIView().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = Constant.Divider.bgColor
    }
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    setSubviewsLayoutPriorities()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience internal init() {
    self.init(frame: .zero)
  }
}

// MARK: - Public helpers
extension PostHeaderSubInfoView {
  func configure(with data: PostHeaderSubInfoModel?) {
    setUserNameLabel(with: data?.userName)
    setDurationLabel(with: data?.duration)
    setYearMonthDayRangeLabel(with: data?.yearMonthDayRange)
  }
}

// MARK: - Helpers
extension PostHeaderSubInfoView {
  private func setUserNameLabel(with text: String?) {
    userNameLabel.text = text
  }
  
  private func setDurationLabel(with text: String?) {
    durationLabel.text = text
  }
  
  private func setYearMonthDayRangeLabel(with text: String?) {
    yearMonthDayRangeLabel.text = text
  }
  
  private func setSubviewsLayoutPriorities() {
    userNameLabel.setContentHuggingPriority(
      UILayoutPriority(252), for: .horizontal)
    userNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    durationLabel.setContentCompressionResistancePriority(
      UILayoutPriority(998), for: .horizontal)
    yearMonthDayRangeLabel.setContentCompressionResistancePriority(
      UILayoutPriority(999), for: .horizontal)
  }
}

// MARK: - Action
private extension PostHeaderSubInfoView {
  @objc func didTapUserName() {
    print("DEBUG: Goto profile section!!")
    UIView.touchAnimate(userNameLabel)
  }
}

// MARK: - LayoutSupport
extension PostHeaderSubInfoView: LayoutSupport {
  func addSubviews() {
    _=[userNameLabel,
       dividerView.first!,
       durationLabel,
       dividerView.last!,
       yearMonthDayRangeLabel].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[userNameLabelConstraints,
       dividerView1Constraints,
       durationLabelConstraints,
       dividerView2Constraints,
       dateRangeLabelConstraints]
      .map {
        NSLayoutConstraint.activate($0)
      }
  }
}

// MARK: - LayoutSupport constraints
private extension PostHeaderSubInfoView {
  var userNameLabelConstraints: [NSLayoutConstraint] {
    return [
      userNameLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor),
      userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      userNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Constant.UserName.width),
      userNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)]
  }
  
  var dividerView1Constraints: [NSLayoutConstraint] {
    let divider = dividerView.first!
    return [
      divider.centerYAnchor.constraint(equalTo: centerYAnchor),
      divider.widthAnchor.constraint(
        equalToConstant: Constant.Divider.width),
      divider.heightAnchor.constraint(
        equalToConstant: Constant.Divider.height),
      divider.leadingAnchor.constraint(
        equalTo: userNameLabel.trailingAnchor,
        constant: Constant.Divider.Spacing.leading)]
  }
  
  var durationLabelConstraints: [NSLayoutConstraint] {
    return [
      durationLabel.centerYAnchor.constraint(
        equalTo: centerYAnchor),
      durationLabel.leadingAnchor.constraint(
        equalTo: dividerView[0].trailingAnchor,
        constant: Constant.Duration.Spacing.leading),
      durationLabel.widthAnchor.constraint(
        lessThanOrEqualToConstant: Constant.Duration.width)]
  }
  
  var dividerView2Constraints: [NSLayoutConstraint] {
    let divider = dividerView.last!
    return [
      divider.centerYAnchor.constraint(equalTo: centerYAnchor),
      divider.widthAnchor.constraint(
        equalToConstant: Constant.Divider.width),
      divider.heightAnchor.constraint(
        equalToConstant: Constant.Divider.height),
      divider.leadingAnchor.constraint(
        equalTo: durationLabel.trailingAnchor,
        constant: Constant.Divider.Spacing.leading)]
  }
  
  var dateRangeLabelConstraints: [NSLayoutConstraint] {
    [yearMonthDayRangeLabel.centerYAnchor.constraint(
      equalTo: centerYAnchor),
     yearMonthDayRangeLabel.leadingAnchor.constraint(
      equalTo: dividerView[1].trailingAnchor,
      constant: Constant.DateRange.Spacing.leading),
     yearMonthDayRangeLabel.trailingAnchor.constraint(
      lessThanOrEqualTo: trailingAnchor)]
  }
}
