//
//  BaseCommentView.swift
//  travelPlan
//
//  Created by 양승현 on 11/9/23.
//

import UIKit

protocol BaseCommentViewDelegate: BaseProfileAreaViewDelegate {
  func didTapProfile()
  func didTapHeart(_ isOnHeart: Bool)
  func didCanceledHeart()
}

final class BasePostDetailCommentableView: BaseProfileAreaView {
  enum UsageType {
    case comment
    case reply
  }
  
  // MARK: - Properties
  private lazy var userNameLabel = BaseLabel(fontType: .medium_500(fontSize: 14)).set {
    $0.textColor = .yg.gray7
    $0.numberOfLines = 1
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
    $0.addGestureRecognizer(tap)
  }
  
  private let timeStampLabel = BaseLabel(fontType: .regular_400(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray3
    $0.numberOfLines = 1
  }
  
  private lazy var headerStackView: UIStackView = .init(arrangedSubviews: [userNameLabel, timeStampLabel]).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
    $0.spacing = 5
    $0.alignment = .leading
  }
  
  private let commentLabel = BaseLabel(fontType: .regular_400(fontSize: 14)).set {
    $0.textColor = .yg.gray7
    $0.numberOfLines = 0
  }
  
  private lazy var heartIcon = UIImageView(image: UIImage(named: "unselectedHeart")?.setColor(.yg.gray3)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeartIcon))
    $0.addGestureRecognizer(tap)
  }
  
  /// 숫자는 highlight 써야합니다.
  private lazy var heartLabel = BaseLabel(fontType: .semiBold_600(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray3
    $0.text = "좋아요"
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didCanceledHeart))
    $0.addGestureRecognizer(tap)
  }
  
  /// CommentType별로 메모리 로드 안 할 수 있음
  private lazy var dotIcon = UIImageView(image: UIImage(named: "commentDot")).set {
    $0.contentMode = .scaleAspectFit
  }
  
  /// CommentType별로 메모리 로드 안 할 수 있음
  private lazy var replyLabel = BaseLabel(fontType: .medium_500(fontSize: 12)).set {
    $0.textColor = .yg.gray3
  }
  
  private var footerStackView: UIStackView?
  
  private let contentStackView: UIStackView
  
  public var isOnHeart = false
  
  public weak var delegate: BaseCommentViewDelegate?
  
  // MARK: - Lifecycle
  init(frame: CGRect, usageType: UsageType) {
    
    switch usageType {
    case .comment:
      footerStackView = UIStackView(arrangedSubviews: [heartLabel, dotIcon, replyLabel])
    case .reply:
      
    }
    
    
    super.init(frame: frame, contentView: <#T##UIView#>, profileLayoutInfo: <#T##BaseProfileAreaView.ProfileInfoType#>)
  }
  
  convenience init(usageType: UsageType) {
    self.init(frame: .zero, usageType: usageType)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  // MARK: - Private Helpers
  
  
  // MARK: - LayoutSupport
  
  // MARK: - LayoutSupport Constraints
}

// MARK: - Helpers
extension BasePostDetailCommentableView {
  func setHeartLabelHeartOnState(_ heartCountText: String) {
    heartLabel.font = UIFont(pretendard: .semiBold_600(fontSize: 12))
    heartLabel.text = " \(heartCountText) 좋아요 취소"
  }
  
  func setHeartLabelHeartOffState(_ heartCountText: String) {
    heartLabel.font = UIFont(pretendard: .medium_500(fontSize: 12))
    heartLabel.text = "\(heartCountText) 좋아요"
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
}
