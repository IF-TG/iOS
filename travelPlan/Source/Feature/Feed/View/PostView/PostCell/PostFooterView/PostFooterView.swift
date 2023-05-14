//
//  PostFooterView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostFooterView: UIView {
  // MARK: - Properties
  private lazy var heartIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleToFill
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapHeart))
    $0.addGestureRecognizer(tap)
  }
  private let heartText = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "0"
    $0.font = Constant.Heart.Text.font
    $0.textColor = Constant.Heart.Text.fontColor
  }
  
  private lazy var commentIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: Constant.Comment.iconName)?.setColor(.yg.gray4)
    $0.contentMode = .scaleToFill
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapComment))
    $0.addGestureRecognizer(tap)
  }
  
  private let commentText = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "0"
    $0.font = Constant.Heart.Text.font
    $0.textColor = Constant.Heart.Text.fontColor
  }
  
  private lazy var shareButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(
      UIImage(named: Constant.Share.iconName)?.setColor(.yg.gray4),
      for: .normal)
    var img = UIImage(named: Constant.Share.iconName)
    img = img?.setColor(.yg.gray4.withAlphaComponent(0.5))
    $0.setImage(img, for: .highlighted)
    $0.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
  }
  
  private lazy var heartStackView = initStackView(heartIcon, heartText, type: .heart)
  
  private lazy var commentStackView = initStackView(commentIcon, commentText, type: .comment)
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Action
fileprivate extension PostFooterView {
  @objc func didTapHeart() {
    print("하트 탭")
    UIView.touchAnimate(heartIcon, scale: 0.85)
  }
  
  @objc func didTapComment() {
    print("커맨드 화면 이동")
    UIView.touchAnimate(commentIcon, scale: 0.85)
  }
  
  @objc func didTapShare() {
    print("share 화면으로 이동")
    UIView.touchAnimate(shareButton, scale: 0.85)
  }
}

// MARK: - Public helpers
extension PostFooterView {
  func configure(with data: PostFooterModel) {
    setHeart(with: String(data.heartCount))
    setHeartIcon(with: data.heartState)
    setComment(with: String(data.commentCount))
  }
}

// MARK: - Helpers
extension PostFooterView {
  private func setHeart(with text: String) {
    heartText.text = text
  }
  
  private func setComment(with text: String) {
    commentText.text = text
  }
  
  private func setHeartIcon(with state: Bool) {
    if state {
      // Set following post state with heartTODO: - 이때 하트중이라는 색과 하트가 올라오는 애니메이션 넣으면 좋을거같아요.
    } else {
      // 하트 취소
      heartIcon.image = Constant.Heart.unselectedImage
    }
  }
  
  private func initStackView(
    _ icon: UIImageView,
    _ text: UIView,
    type: PostFooterStackViewType
  ) -> UIStackView {
    _=[icon, text].map { addSubview($0) }
    return UIStackView(arrangedSubviews: [icon, text]).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.distribution = .fillEqually
      $0.alignment = .center
      switch type {
      case .heart:
        $0.spacing = Constant.HeartSV.spacing
        setHeartIconMinimumSize(icon)
      case .comment:
        $0.spacing = Constant.CommentSV.spacing
        setCommentIconMinimumSize(icon)
      }
      $0.heightAnchor.constraint(equalToConstant: Constant.HeartSV.height).isActive = true
    }
  }
  
  private func setCommentIconMinimumSize(_ icon: UIImageView) {
    NSLayoutConstraint.activate([
      icon.widthAnchor.constraint(equalToConstant: Constant.Comment.minimumsSize.width),
      icon.heightAnchor.constraint(equalToConstant: Constant.Comment.minimumsSize.height)])
  }
  
  private func setHeartIconMinimumSize(_ icon: UIImageView) {
    NSLayoutConstraint.activate([
      icon.widthAnchor.constraint(equalToConstant: Constant.Heart.minimumsSize.width),
      icon.heightAnchor.constraint(equalToConstant: Constant.Heart.minimumsSize.height)])
  }
}

// MARK: - LayoutSupport
extension PostFooterView: LayoutSupport {
  func addSubviews() {
    _=[heartStackView, commentStackView, shareButton].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[heartStackViewConstraint,
       commentStackViewConstraint,
       shareIconConstraint].map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostFooterView {
  var heartStackViewConstraint: [NSLayoutConstraint] {
    [heartStackView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.HeartSV.Spacing.leading),
     heartStackView.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var commentStackViewConstraint: [NSLayoutConstraint] {
    [commentStackView.leadingAnchor.constraint(
      equalTo: heartStackView.trailingAnchor,
      constant: Constant.CommentSV.Spacing.leading),
     commentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var shareIconConstraint: [NSLayoutConstraint] {
    [
      shareButton.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.Share.Spacing.trailing),
      shareButton.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
}
