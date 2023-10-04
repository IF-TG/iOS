//
//  EmptyStateView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

final class EmptyStateView: UIView {
  enum Constant {
    enum Icon {
      static let size = CGSize(width: 50, height: 50)
    }
    
    enum TitleLabel {
      enum Spacing {
        static let top: CGFloat = 15
      }
    }
    
    enum contentLabel {
      enum Spacing {
        static let top: CGFloat = 20
      }
    }
  }
  
  enum UseageType {
    case emptyNotifiation
    case disabledNotification
    case emptyTravelPost
    case emptyTravelLocation
    case customEmpty(imagePath: String, title: String, content: String)
    
    var iconPath: String {
      switch self {
      case .emptyNotifiation:
        return "emptyNotificationBell"
      case .disabledNotification:
        return "disabledNotificationBell"
      case .emptyTravelPost:
        return "emptyStateStar"
      case .emptyTravelLocation:
        return "emptyStateStar"
      case .customEmpty(let path, _, _):
        return path
      }
    }
    
    var titleFont: UIFont {
      return .systemFont(ofSize: 15, weight: .init(600))
    }
    
    var contentFont: UIFont {
      return .systemFont(ofSize: 13, weight: .init(400))
    }
    
    var textColor: UIColor {
      return .YG.gray1
    }
    
    var title: String {
      switch self {
      case .emptyNotifiation:
        return "새로운 알림이 없어요."
      case .disabledNotification:
        return "알림이 꺼져있어요."
      case .emptyTravelPost:
        return "여행 리뷰가 비어있어요."
      case .emptyTravelLocation:
        return "여행 장소가 비어있어요."
      case .customEmpty(_, let title, _):
        return title
      }
    }
    
    var content: String {
      switch self {
      case .emptyNotifiation:
        return "여행자들의 흥미로운 소식을 알림으로 받아보세요!"
      case .disabledNotification:
        return "흥미로운 플랜과 리뷰를 둘러보러 가볼까요?"
      case .emptyTravelPost,
          .emptyTravelLocation:
        return "여행자들의 리뷰와 장소를 찜해보세요."
      case .customEmpty(_, _, let content):
        return content
      }
    }
  }
  
  // MARK: - Properties
  private let state: UseageType
  
  private lazy var icon: UIImageView = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: state.iconPath)
  }
  
  private lazy var titleLabel: UILabel = UILabel(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .center
    $0.font = state.titleFont
    $0.textColor = state.textColor
    $0.numberOfLines = 1
    $0.text = state.title
    $0.sizeToFit()
  }
  
  private lazy var contentLabel: UILabel = UILabel(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .center
    $0.font = state.contentFont
    $0.textColor = state.textColor
    /// 최대 2문장까지
    $0.numberOfLines = 0
    $0.text = state.content
    $0.sizeToFit()
  }
  
  // MARK: - Lifecycle
  init(frame: CGRect, state: UseageType) {
    self.state = state
    super.init(frame: frame)
    configureUI()
  }
  
  convenience init(state: UseageType) {
    self.init(frame: .zero, state: state)
  }
  
  required init?(coder: NSCoder) {
    state = .emptyNotifiation
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Private Helpers
private extension EmptyStateView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
}

// MARK: - LayoutSupport
extension EmptyStateView: LayoutSupport {
  func addSubviews() {
    _=[
      icon,
      titleLabel,
      contentLabel
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      iconConstraints,
      titleLabelConstraints,
      contentLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension EmptyStateView {
  var iconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.Icon
    return [
      icon.widthAnchor.constraint(equalToConstant: Const.size.width),
      icon.heightAnchor.constraint(equalToConstant: Const.size.height),
      icon.topAnchor.constraint(equalTo: topAnchor),
      icon.centerXAnchor.constraint(equalTo: centerXAnchor)]
  }
  
  var titleLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TitleLabel.Spacing
    return [
      titleLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: Spacing.top),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)]
  }
  
  var contentLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.contentLabel.Spacing
    return [
      contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.top),
      contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentLabel.heightAnchor.constraint(lessThanOrEqualToConstant: state.contentFont.lineHeight*2)]
  }
}
