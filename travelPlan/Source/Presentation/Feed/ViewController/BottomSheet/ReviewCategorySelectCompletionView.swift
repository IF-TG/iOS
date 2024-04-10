//
//  ReviewCategorySelectCompletionView.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit

final class ReviewCategorySelectCompletionView: UIView {
  // MARK: - Properties
  private let choiceHelpView = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 16.67, height: 16.67), iconPath: "circle_exclamation_icon"),
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: 20)
  ).set {
    $0.setCountLabel(text: "다양한 테마를 선택해 보세요.")
    $0.setLabelColor(.yg.gray2)
  }
  
  private let clearButton = PrimaryColorToneRoundButton(currentState: .normal).set {
    $0.setTitle("초기화", for: .normal)
    $0.setTitleColor(.yg.gray3, for: .normal)
    $0.layer.borderWidth = 1.5
    $0.layer.borderColor = UIColor.yg.primary.withAlphaComponent(0.3).cgColor
    $0.backgroundColor = .white
  }
  
  private let okButton = PrimaryColorToneRoundButton(currentState: .normal).set {
    $0.setTitle("확인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .yg.primary.withAlphaComponent(0.3)
    $0.isUserInteractionEnabled = false
  }
  
  var okButtonTap: (() -> Void)? {
    get {
      okButton.tapHandler
    } set {
      okButton.tapHandler = newValue
    }
  }
  
  var clearButtonTap: (() -> Void)? {
    get {
      clearButton.tapHandler
    } set {
      clearButton.tapHandler = newValue
    }
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) { nil }
  
  // MARK: - Helpers
  func activeOKButtonUI() {
    okButton.isUserInteractionEnabled = true
    UIView.animate(withDuration: 0.2) {
      self.okButton.backgroundColor = .yg.primary
    }
  }
  
  func deactiveOKButtonUI() {
    okButton.isUserInteractionEnabled = false
    UIView.animate(withDuration: 0.2) {
      self.okButton.backgroundColor = .yg.primary.withAlphaComponent(0.3)
    }
  }
}
// MARK: - LayoutSupport
extension ReviewCategorySelectCompletionView: LayoutSupport {
  func addSubviews() {
    [choiceHelpView, clearButton, okButton].forEach { addSubview($0) }
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      choiceHelpView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.67),
      choiceHelpView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
      clearButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
      clearButton.topAnchor.constraint(equalTo: choiceHelpView.bottomAnchor, constant: 12),
      clearButton.heightAnchor.constraint(equalToConstant: 48),
      clearButton.widthAnchor.constraint(equalTo: okButton.widthAnchor),
      okButton.heightAnchor.constraint(equalToConstant: 48),
      okButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 7),
      okButton.topAnchor.constraint(equalTo: choiceHelpView.bottomAnchor, constant: 12),
      okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
      okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)])
  }
}
