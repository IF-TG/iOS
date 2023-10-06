//
//  EmptyStateView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

final class EmptyStateView: UIView {
  enum Constant {
    enum TitleLabel {
      enum Spacing {
        static let top: CGFloat = 15
      }
    }
    
    enum ContentLabel {
      enum Spacing {
        static let top: CGFloat = 10
      }
    }
  }
  
  enum UseageType {
    case emptyNotifiation
    case disabledNotification
    case emptyTravelPost
    case emptyTravelLocation
    case custom(iconPath: String, iconSize: CGSize, title: String, content: String)
    
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
      case .custom(let path, _, _, _):
        return path
      }
    }
    
    var iconSize: CGSize {
      switch self {
      case .emptyTravelPost,
           .emptyTravelLocation:
        return .init(width: 48, height: 48)
      case .emptyNotifiation,
           .disabledNotification:
        return .init(width: 50, height: 50)
      case .custom(_, let size, _, _):
        return size
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
      case .custom(_, _, let title, _):
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
      case .custom(_, _, _, let content):
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
  
  override var intrinsicContentSize: CGSize {
    let width = 260.0
    let iconAreaHeight = state.iconSize.height
    let titleAreaHeight = Constant.TitleLabel.Spacing.top + state.titleFont.lineHeight
    let contentAreaHeight = Constant.ContentLabel.Spacing.top + state.contentFont.lineHeight * 2
    let height = iconAreaHeight + titleAreaHeight + contentAreaHeight
    return .init(width: width, height: height)
  }
  
  private(set) var isFirstAnimation = false
  
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

// MARK: - Helpers
extension EmptyStateView {
  /// 애니메이션을 사용하려면 viewWillAppear 시점에 호출해 주세요.
  func prepareAnimation() {
    guard !isFirstAnimation else {
      return
    }
    icon.alpha = 0.12
    icon.backgroundColor = .white
    titleLabel.alpha = 0
    titleLabel.transform = .init(translationX: -30, y: 0)
    contentLabel.alpha = 0
    contentLabel.transform = .init(translationX: -30, y: 0)
  }
  
  /// 애니메이션을 사용하려면 viewDidAppaer 시점에 호출해 주세요.
  func showAnimation() {
    guard !isFirstAnimation else {
      return
    }
    isFirstAnimation.toggle()
    UIView.transition(
      with: icon,
      duration: 1.1,
      options: [.curveEaseOut, .transitionCurlDown, .curveEaseIn],
      animations: {
        self.icon.alpha = 1
      })
    UIView.animate(
      withDuration: 0.75,
      delay: 0.5,
      options: [.curveEaseOut],
      animations: {
        self.titleLabel.transform = .identity
        self.titleLabel.alpha = 1
      })
    UIView.animate(
      withDuration: 0.75,
      delay: 0.9,
      options: [.curveEaseOut],
      animations: {
        self.contentLabel.transform = .identity
        self.contentLabel.alpha = 1
      })
  }
}

// MARK: - Private Helpers
private extension EmptyStateView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    backgroundColor = .white
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
    return [
      icon.widthAnchor.constraint(equalToConstant: state.iconSize.width),
      icon.heightAnchor.constraint(equalToConstant: state.iconSize.height),
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
    typealias Spacing = Constant.ContentLabel.Spacing
    return [
      contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.top),
      contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentLabel.heightAnchor.constraint(lessThanOrEqualToConstant: state.contentFont.lineHeight*2)]
  }
}