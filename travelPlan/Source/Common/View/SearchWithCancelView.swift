//
//  SearchWithCancelView.swift
//  travelPlan
//
//  Created by 양승현 on 10/7/23.
//

import UIKit
import Combine

final class SearchWithCancelView: UIView {
  enum EditingState {
    case origin
    case good
    case excess
    
    var borderColor: CGColor {
      var color: UIColor
      switch self {
      case .origin:
        color = .yg.gray0
      case .good:
        color = .yg.primary
      case .excess:
        color = .yg.red2
      }
      return color.cgColor
    }
  }
  
  enum Constant {
    static let height: CGFloat = TextField.font.lineHeight + TextField.Spacing.top + TextField.Spacing.bottom
    static let radius: CGFloat = 2
    static let borderWidth: CGFloat = 0.5
    
    enum TextField {
      static let font = UIFont(pretendard: .medium_500(fontSize: 16))!
      enum Spacing {
        static let top: CGFloat = 6
        static let bottom = top
        static let leading: CGFloat = 9
        static let trailing: CGFloat = 26
      }
    }
    
    enum CancelButton {
      static let size: CGSize = .init(width: 16, height: 16)
      static let iconName = "xCircle"
      enum Spacing {
        static let trailing: CGFloat = 8
      }
    }
  }
  
  // MARK: - Properties
  private let textField = UITextField(frame: .zero).set {
    typealias Const = Constant.TextField
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.placeholder = "폴더명을 입력해주세요."
    $0.font = Const.font
    $0.textAlignment = .natural
    $0.keyboardType = .default
  }
  
  private let cancelButton = UIButton(frame: .zero).set {
    typealias Const = Constant.CancelButton
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.tintColor = .white
    $0.setImage(UIImage(named: Const.iconName), for: .normal)
  }
  
  private let textExcessAlertLabel = UILabel(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "입력 가능한 글자수를 초과했습니다."
    $0.font = .init(pretendard: .medium_500(fontSize: 12))
    $0.textColor = .yg.red2
    $0.alpha = 0
  }
  
  private var isTextExcessAlertExecuted = false
  
  var changed: AnyPublisher<String, Never> {
    textField.changed
  }
  
  var text: String? {
    textField.text
  }
  
  var textClear: (() -> Void)?
  
  var editingState: EditingState = .origin {
    didSet {
      if editingState != .excess {
        // TODO: - 애니메이션 실행 스택을 취소하는 새로운 애니메이션 도입해야합니다.
        isTextExcessAlertExecuted = false
        textExcessAlertLabel.isHidden = true
        textExcessAlertLabel.alpha = 0
        textExcessAlertLabel.transform = .identity
      }
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseOut
      ) {
        self.layer.borderColor = self.editingState.borderColor
      }
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 150, height: Constant.height)
  }
  
  private var cancelSubscription: AnyCancellable?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: .zero)
    configureUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    bind()
  }
}

// MARK: - Helpers
extension SearchWithCancelView {
  func showTextExcessAlertLabel() {
    guard !isTextExcessAlertExecuted else { return }
    isTextExcessAlertExecuted = true
    textExcessAlertLabel.isHidden = false
    let targetY = textExcessAlertLabel.font.lineHeight
    UIView.transition(
      with: textExcessAlertLabel,
      duration: 0.3,
      options: [.curveEaseIn],
      animations: {
        self.textExcessAlertLabel.alpha = 1
        self.textExcessAlertLabel.transform = .init(translationX: 0, y: -targetY)
      }, completion: { _ in
        UIView.animate(
          withDuration: 0.3,
          delay: 1.3,
          options: .curveEaseOut,
          animations: {
            self.textExcessAlertLabel.alpha = 0
            self.textExcessAlertLabel.transform = .identity
          })
      })
  }
  
  func setTextFieldInputAccessory(_ view: UIView?) {
    textField.inputAccessoryView = view
  }
  
  func hideKeyboard() {
    textField.resignFirstResponder()
  }
  
  func showKeyboard() {
    textField.becomeFirstResponder()
  }

}

// MARK: - Private Helpers
private extension SearchWithCancelView {
  func configureUI() {
    typealias Const = Constant
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderColor = editingState.borderColor
    layer.borderWidth = Const.borderWidth
    layer.cornerRadius = Const.radius
    setupUI()
  }
  
  func bind() {
    cancelSubscription = cancelButton.tap
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.textField.text = ""
        self?.textClear?()
        self?.editingState = .origin
      }
  }
}

// MARK: - LayoutSupport
extension SearchWithCancelView: LayoutSupport {
  func addSubviews() {
    _=[
      textField,
      cancelButton,
      textExcessAlertLabel
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      textFieldConstraints,
      cancelButtonConstraints,
      textExcessAlertLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension SearchWithCancelView {
  var textFieldConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TextField.Spacing
    return [
      textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      textField.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var cancelButtonConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CancelButton
    typealias Spacing = Const.Spacing
    return [
      cancelButton.widthAnchor.constraint(equalToConstant: Const.size.width),
      cancelButton.heightAnchor.constraint(equalToConstant: Const.size.height),
      cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var textExcessAlertLabelConstraints: [NSLayoutConstraint] {
    return [
      textExcessAlertLabel.topAnchor.constraint(equalTo: topAnchor),
      textExcessAlertLabel.trailingAnchor.constraint(equalTo: trailingAnchor)]
  }
}
