//
//  SettingUserNameTextField.swift
//  travelPlan
//
//  Created by 양승현 on 11/28/23.
//

import UIKit
import Combine

final class SettingUserNameTextField: UITextField {
  // MARK: - Nested
  enum State {
    case normal
    // 새로운 닉네임 변환 가능
    case available
    // 중복
    case duplicated
    // 입력된 길이 초과
    case overflow
    
    var quotation: String {
      switch self {
      case .normal:
        return ""
      case .available:
        return "사용 가능한 닉네임입니다"
      case .duplicated:
        return "중복된 닉네임입니다. 바꿔주세요."
      case .overflow:
        return "닉네임 "
      }
    }
    
    var borderColor: CGColor {
      switch self {
      case .normal:
        return UIColor.yg.gray5.cgColor
      case .available:
        return UIColor.yg.primary.cgColor
      case .duplicated, .overflow:
        return UIColor.yg.red2.cgColor
      }
    }
    
    var noticeIconPath: String {
      ""
    }
  }
  
  /// 서버에 체크 후 사용가능한지에 따라 textState를 변화해야합니다.
  @Published var textState: State = .normal {
    didSet {
      layer.borderColor = textState.borderColor
      if textState != .normal {
        noticeIcon.image = UIImage(named: textState.noticeIconPath)
      }
    }
  }
  
  // MARK: - Properties
  private var noticeIcon = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Public Helpers
extension SettingUserNameTextField {
  func setTextAvailableState() {
  }
}

// MARK: - Private Helpers
extension SettingUserNameTextField {
  func configureUI() {
    layer.borderWidth = 1.5
    layer.cornerRadius = 5
    let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: 10, height: frame.height))
    let rightPaddingView = UIView(frame: .init(x: 0, y: 0, width: 40.5, height: frame.height))
    leftView = leftPaddingView
    rightView = rightPaddingView
    setupUI()
  }
}

extension SettingUserNameTextField: LayoutSupport {
  func addSubviews() {
    addSubview(noticeIcon)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      noticeIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
      noticeIcon.widthAnchor.constraint(equalToConstant: 15),
      noticeIcon.heightAnchor.constraint(equalToConstant: 15),
      noticeIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.5)])
  }
}