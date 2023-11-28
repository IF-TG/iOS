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
    case initial
    
    case normal
    // 새로운 닉네임 변환 가능
    case available
    // 중복
    case duplicated
    // 입력된 길이 초과
    case overflow
    
    var quotation: String {
      switch self {
      case .normal, .initial:
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
      case .initial:
        return UIColor.yg.gray2.cgColor
      case .normal:
        return UIColor.yg.gray5.cgColor
      case .available:
        return UIColor.yg.primary.cgColor
      case .duplicated, .overflow:
        return UIColor.yg.red2.cgColor
      }
    }
    
    var noticeIconPath: String {
      switch self {
      case .duplicated, .overflow:
        return "x-circle-delete"
      case .available:
        return "v-circle-success"
      default:
        /// 옵셔널 지정 생성자의 장점은 init을 할수없다면 nil반환한다는것입니다.
        return ""
      }
    }
  }
  
  private var isSpaceViewSet = false
  
  /// 서버에 체크 후 사용가능한지에 따라 textState를 변화해야합니다.
  @Published var textState: State = .initial {
    didSet {
      layer.borderColor = textState.borderColor
      noticeIcon.image = UIImage(named: textState.noticeIconPath)
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
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
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
    layer.borderColor = textState.borderColor
    setupUI()
    let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: 10, height: CGFloat.leastNormalMagnitude))
    let rightPaddingView = UIView(frame: .init(x: 0, y: 0, width: 40.5, height: CGFloat.leastNormalMagnitude))
    leftView = leftPaddingView
    rightView = rightPaddingView
    leftViewMode = .always
    rightViewMode = .always
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
