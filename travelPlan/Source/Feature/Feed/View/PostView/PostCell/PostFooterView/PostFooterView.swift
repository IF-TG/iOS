//
//  PostFooterView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostFooterView: UIView {
  // MARK: - Properties
  
  /// 초기 사용자가 포스트에 대해서 하트를 눌렀는지 상태 체크
  private var postHeartState: Bool? = false
  
  private lazy var heartIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapHeart))
    $0.addGestureRecognizer(tap)
  }
  
  private let heartText = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "0"
    $0.textAlignment = .left
    $0.font = Constant.Heart.Text.font
    $0.textColor = Constant.Heart.Text.fontColor
  }
  
  private lazy var commentIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: Constant.Comment.Icon.name)?.setColor(.yg.gray4)
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapComment))
    $0.addGestureRecognizer(tap)
  }
  
  private let commentText = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "0"
    $0.textAlignment = .left
    $0.font = Constant.Heart.Text.font
    $0.textColor = Constant.Heart.Text.fontColor
  }
  
  private lazy var shareButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    $0.setImage(
      UIImage(named: Constant.Share.iconName)?.setColor(.yg.gray4),
      for: .normal)
    var img = UIImage(named: Constant.Share.iconName)
    img = img?.setColor(.yg.gray4.withAlphaComponent(0.5))
    $0.setImage(img, for: .highlighted)
    $0.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
  }
  
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
    // 여기선 서버로 하트 취소한거 처리 해야합니다TODO: - 하트 취소, 수락 서버 갱신
    updatePostHeartState()
    print("DEBUG: 찜")
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
  func configure(with data: PostFooterModel?) {
    setHeart(with: String(data?.heartCount ?? 0))
    setHeartIcon(with: data?.heartState ?? false)
    setComment(with: String(data?.commentCount ?? 0))
  }
  
  func updatePostHeartState() {
    /// 여기서 서버 포스트에 대한 로그인 사용자 포스트 상태 관련 처리
    guard let heartState = postHeartState else {
      setHeartIcon(with: false)
      postHeartState = false
      return
    }
    postHeartState = !heartState
    guard postHeartState! else {
      setHeartIcon(with: false)
      unselectedHeartAnim()
      return
    }
    setHeartIcon(with: true)
    selectedHeartAnim()
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
    postHeartState = state
    if state {
      heartIcon.image = Constant.Heart.Icon.selectedImage
    } else {
      // 하트 취소
      heartIcon.image = Constant.Heart.Icon.unselectedImage
    }
  }
  
  private func selectedHeartAnim() {
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
  private func unselectedHeartAnim() {
    heartIcon.alpha = 0.0
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      options: .curveEaseOut) {
        self.heartIcon.alpha = 1.0
    }
  }
}

// MARK: - LayoutSupport
extension PostFooterView: LayoutSupport {
  func addSubviews() {
    _=[heartIcon, heartText,
       commentIcon, commentText, shareButton]
      .map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[heartIconConstraint,
       heartTextConstraint,
       commentIconConstraint,
       commentTextConstraint,
       shareIconConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostFooterView {
  typealias Layout = NSLayoutConstraint
  var heartIconConstraint: [Layout] {
    [heartIcon.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.Heart.Icon.Spacing.leading),
     heartIcon.centerYAnchor.constraint(
      equalTo: centerYAnchor),
     heartIcon.widthAnchor.constraint(
      equalToConstant: Constant.Heart.Icon.minimumsSize.width),
     heartIcon.heightAnchor.constraint(
      equalToConstant: Constant.Heart.Icon.minimumsSize.height)]
  }
  
  var heartTextConstraint: [Layout] {
    heartText.sizeToFit()
    return [
      heartText.leadingAnchor.constraint(
        equalTo: heartIcon.trailingAnchor,
        constant: Constant.Heart.Text.Spacing.leading),
      heartText.centerYAnchor.constraint(
        equalTo: centerYAnchor)]
  }
  
  var commentIconConstraint: [Layout] {
    [commentIcon.leadingAnchor.constraint(
      equalTo: heartText.trailingAnchor,
      constant: Constant.Comment.Icon.Spacing.leading),
     commentIcon.centerYAnchor.constraint(
      equalTo: centerYAnchor),
     commentIcon.widthAnchor.constraint(
      equalToConstant: Constant.Comment.Icon.minimumsSize.width),
     commentIcon.heightAnchor.constraint(
      equalToConstant: Constant.Comment.Icon.minimumsSize.height)]
  }
  
  var commentTextConstraint: [Layout] {
    commentText.sizeToFit()
    return [
      commentText.leadingAnchor.constraint(
        equalTo: commentIcon.trailingAnchor,
        constant: Constant.Comment.Text.Spacing.leading),
      commentText.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var shareIconConstraint: [Layout] {
    [
      shareButton.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.Share.Spacing.trailing),
      shareButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: Constant.Share.height),
      shareButton.widthAnchor.constraint(equalToConstant: Constant.Share.width)]
  }
}
