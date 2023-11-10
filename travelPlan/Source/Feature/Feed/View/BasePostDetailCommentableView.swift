//
//  BasePostDetailCommentableView.swift
//  travelPlan
//
//  Created by 양승현 on 11/9/23.
//

import UIKit

struct BasePostDetailCommentInfo {
  let commentId: Int64
  let userName: String
  let userProfileURL: String
  let timestamp: String
  let comment: String
  let isOnHeart: Bool
  let heartCountText: String
}

protocol BaseCommentViewDelegate: BaseProfileAreaViewDelegate {
  func didTapProfile()
  func didTapHeart(_ isOnHeart: Bool)
  func didCanceledHeart()
  func didTapReply()
}

final class BasePostDetailCommentableView: BaseProfileAreaView {
  enum UsageType {
    case comment
    case reply
  }
  
  // MARK: - Properties
  private let userNameLabel = BaseLabel(fontType: .medium_500(fontSize: 14)).set {
    $0.textColor = .yg.gray7
    $0.numberOfLines = 1
    $0.isUserInteractionEnabled = true
  }
  
  // TODO: - 어떻게 시간 지남을 구하고 표시할것인가?
  private let timeStampLabel = BaseLabel(fontType: .regular_400(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray3
    $0.numberOfLines = 1
  }
  
  private let commentLabel = BaseLabel(fontType: .regular_400(fontSize: 14)).set {
    $0.textColor = .yg.gray7
    $0.numberOfLines = 0
  }
  
  private let heartIcon = UIImageView(image: UIImage(named: "unselectedHeart")?.setColor(.yg.gray3)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.isUserInteractionEnabled = true
  }
  
  /// 숫자는 highlight 써야합니다.
  private let heartLabel = BaseLabel(fontType: .medium_500(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray3
    $0.text = "좋아요"
    $0.isUserInteractionEnabled = true
  }
  
  private lazy var heartCancelLabel = BaseLabel(fontType: .semiBold_600(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray3
    $0.text = "취소"
    $0.isUserInteractionEnabled = true
  }
  
  /// CommentType별로 메모리 로드 안 할 수 있음
  private lazy var dotIcon = UIImageView(image: UIImage(named: "commentDot")).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    $0.widthAnchor.constraint(equalToConstant: 2).isActive = true
    $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
  }
  
  /// CommentType별로 메모리 로드 안 할 수 있음
  private lazy var replyLabel = BaseLabel(fontType: .medium_500(fontSize: 12)).set {
    $0.textColor = .yg.gray3
    $0.text = "답글 달기"
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapReply))
    $0.addGestureRecognizer(tap)
  }
  
  public var isOnHeart = false {
    didSet {
      animateHeartCancelLabel()
      if isOnHeart {
        animateSelectedHeartIcon()
      } else {
        animateDeselectedHeartIcon()
      }
    }
  }
  
  private lazy var heartCancelLabelAnimator = UIViewPropertyAnimator(
    duration: 0.28,
    curve: .easeInOut
  ) {
    self.heartCancelLabel.layoutIfNeeded()
  }
  
  public weak var delegate: BaseCommentViewDelegate?
  
  // MARK: - Lifecycle
  init(frame: CGRect, usageType: UsageType) {
    /// 닉네임, 업로드 시간 스택 뷰
    let headerStackView = UIStackView(arrangedSubviews: [userNameLabel, timeStampLabel]).set {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.spacing = 5
      $0.alignment = .leading
    }
    heartIcon.widthAnchor.constraint(equalToConstant: 13.33).isActive = true
    heartIcon.heightAnchor.constraint(equalToConstant: 11.89).isActive = true
    let heartStackView = UIStackView(arrangedSubviews: [heartIcon, heartLabel]).set {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.spacing = 2
      $0.alignment = .center
    }
    /// usageType == comment인 경우 사용 하지 않습니다.
    /// 하트, 좋아요 취소 및 답글달기 영역 스택 뷰
    var footerStackView: UIStackView?
    
    var contentSubviews = [headerStackView, commentLabel]
    
    switch usageType {
    case .comment:
      /// 하트, 좋아요 취소 답글달기  영역 뷰
      let footerTempStackView = UIStackView(arrangedSubviews: [heartStackView]).set {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 8
        $0.alignment = .center
      }
      footerStackView = footerTempStackView
      contentSubviews.append(footerTempStackView)
    case .reply:
      contentSubviews.append(heartStackView)
    }
    let contentStackView = UIStackView(arrangedSubviews: contentSubviews).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.axis = .vertical
      $0.spacing = 6
      $0.alignment = .top
      $0.distribution = .equalSpacing
    }
    super.init(
      frame: frame,
      contentView: contentStackView,
      contentViewSpacing: .init(top: 3, left: 10, bottom: 3, right: 30),
      profileLayoutInfo: usageType == .comment ? .medium(.top) : .small(.top))
    
    if usageType == .comment {
      [dotIcon, replyLabel].forEach { footerStackView?.addArrangedSubview($0) }
    }
    setUserNameTapGesture()
    setHeartIconTapGesture()
    setHeartCancelLabelTapGesture()
  }
  
  convenience init(usageType: UsageType) {
    self.init(frame: .zero, usageType: usageType)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension BasePostDetailCommentableView {
  func configure(with info: BasePostDetailCommentInfo?) {
    super.configure(with: info?.userProfileURL)
    userNameLabel.text = info?.userName
    timeStampLabel.text = info?.timestamp
    commentLabel.text = info?.comment
    isOnHeart = info?.isOnHeart ?? false
    guard info?.isOnHeart == true else {
      heartIcon.image = UIImage(named: "unselectedHeart")?.setColor(.yg.gray3)
      heartCancelLabel.isHidden = true
      setHeartLabelHeartOffState(info?.heartCountText ?? "")
      return
    }
    setHeartLabelHeartOnState(info?.heartCountText ?? "")
    heartCancelLabel.isHidden = false
    heartIcon.image = UIImage(named: "selectedHeart")?.setColor(.yg.red)
  }
  
  func setHeartLabelHeartOnState(_ heartCountText: String) {
    heartLabel.font = UIFont(pretendard: .semiBold_600(fontSize: 12))
    heartLabel.text = " \(heartCountText) 좋아요 취소"
  }
  
  func setHeartLabelHeartOffState(_ heartCountText: String) {
    heartLabel.font = UIFont(pretendard: .medium_500(fontSize: 12))
    heartLabel.text = "\(heartCountText) 좋아요"
  }
}

// MARK: - Private Helpers
extension BasePostDetailCommentableView {
  private func setUserNameTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
    userNameLabel.addGestureRecognizer(tap)
  }
  
  private func setHeartIconTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeartIcon))
    heartIcon.addGestureRecognizer(tap)
  }
  
  private func setHeartCancelLabelTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didCanceledHeart))
    heartCancelLabel.addGestureRecognizer(tap)
  }
  
  private func animateHeartCancelLabel() {
    heartCancelLabelAnimator.stopAnimation(true)
    self.heartCancelLabel.isHidden = !self.isOnHeart
    heartCancelLabelAnimator.startAnimation()
  }
  
  private func animateSelectedHeartIcon() {
    heartIcon.image = UIImage(named: "selectedHeart")?.setColor(.yg.red)
    heartIcon.alpha = 0.0
    heartIcon.transform = CGAffineTransform(scaleX: 0, y: 0)
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      options: .curveEaseInOut) {
        self.heartIcon.alpha = 1.0
        self.heartIcon.transform = CGAffineTransform(scaleX: 1, y: 1)
      }
  }
  
  private func animateDeselectedHeartIcon() {
    heartIcon.image = UIImage(named: "unselectedHeart")?.setColor(.yg.gray3)
    heartIcon.alpha = 0.0
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      options: .curveEaseOut) {
        self.heartIcon.alpha = 1.0
      }
  }
}

// MARK: - Actions
private extension BasePostDetailCommentableView {
  @objc func didTapHeartIcon() {
    delegate?.didTapHeart(isOnHeart)
  }
  
  @objc func didCanceledHeart() {
    guard isOnHeart else { return }
    delegate?.didCanceledHeart()
  }
  
  @objc func didTapReply() {
    delegate?.didTapReply()
  }
}
