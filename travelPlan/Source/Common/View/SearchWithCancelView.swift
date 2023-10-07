//
//  SearchWithCancelView.swift
//  travelPlan
//
//  Created by 양승현 on 10/7/23.
//

import UIKit
import Combine

final class SearchWithCancelView: UIView {
  enum Constant {
    static let radius: CGFloat = 2
    static let borderWidth: CGFloat = 0.5
    static let borderColor: UIColor = .yg.gray0
    
    enum TextField {
      static let font = UIFont(pretendard: .medium, size: 16)!
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
  
  var changed: AnyPublisher<String, Never> {
    textField.changed
  }
  
  var text: String? {
    textField.text
  }
  
  override var intrinsicContentSize: CGSize {
    typealias Const = Constant.TextField
    typealias Spacing = Const.Spacing
    let height = Const.font.lineHeight + Spacing.top + Spacing.bottom
    return .init(width: 150, height: height)
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

  // MARK: - Private Helpers
private extension SearchWithCancelView {
  func configureUI() {
    typealias Const = Constant
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderColor = Const.borderColor.cgColor
    layer.borderWidth = Const.borderWidth
    layer.cornerRadius = Const.radius
    setupUI()
  }
  
  func bind() {
    cancelSubscription = cancelButton.tap
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.textField.text = nil
      }
  }
}

// MARK: - LayoutSupport
extension SearchWithCancelView: LayoutSupport {
  func addSubviews() {
    _=[
      textField,
      cancelButton
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      textFieldConstraints,
      cancelButtonConstraints
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
}
