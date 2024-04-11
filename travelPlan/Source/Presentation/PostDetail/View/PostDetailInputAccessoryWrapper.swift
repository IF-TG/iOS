//
//  PostDetailInputAccessoryWrapper.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

protocol PostDetailInputAccessoryWrapperDelegate: AnyObject {
  func didTouchSendIcon(_ text: String)
}

final class PostDetailInputAccessoryWrapper: UIView {
  // MARK: - Properties
  private let contentView = PostProfileAndCommentView()
  
  private let tooltipView = BottomBasedTooltipView(
    frame: .zero,
    tipPosition: .right, 
    colorInfo: .init(color: .yg.primary, opacity: 0.8, radius: 7, offset: .init(width: 0, height: 2)),
    message: "글을 수정한 후에 전송할 수 있습니다.",
    textColor: .white,
    labelFontType: .regular_400(fontSize: 14)).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.alpha = 0
    }
  
  weak var delegate: PostDetailInputAccessoryWrapperDelegate?
  
  private var isAnimating = false
  
  private let insets: UIEdgeInsets = .init(top: 10, left: 11, bottom: 10, right: 11)
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    backgroundColor = .white
    contentView.inputDelegate = self
    contentView.baseDelegate = self
    configure(with: "default_profile_icon")
    bind()
  }
  
  override var intrinsicContentSize: CGSize {
    let size = contentView.intrinsicContentSize
    return CGSize(
      width: size.width + insets.left + insets.right,
      height: size.height + insets.top + insets.bottom)
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Private Helpers
private extension PostDetailInputAccessoryWrapper {
  func bind() {
    contentView.editingTextNotChangedHandler = { [weak self] in
      self?.performTooltipAnimation()
    }
  }
  
  func performTooltipAnimation() {
    if isAnimating { return }
    isAnimating.toggle()
    let springAnimation = CASpringAnimation(keyPath: "position.y").set {
      $0.fromValue = tooltipView.layer.position.y
      $0.toValue = tooltipView.layer.position.y + 1
      $0.duration = $0.settlingDuration
      $0.damping = 40
      $0.mass = 10
      $0.initialVelocity = 200
      $0.stiffness = 1500
    }

    let animationGroup = CAAnimationGroup().set {
      $0.duration = max(0.5, springAnimation.duration)
      $0.beginTime = CACurrentMediaTime() + 0.5
    }
    
    UIView.animate(withDuration: 0.5, delay: 0.45, options: [.curveEaseInOut]) {
      self.tooltipView.alpha = 1
    }
    
    animationGroup.animations = [springAnimation]
    
    tooltipView.layer.add(animationGroup, forKey: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.hideTooltipWithAnimation()
    }
  }
  
  func hideTooltipWithAnimation() {
    let moveAnimation = CABasicAnimation(keyPath: "position.y").set {
      $0.fromValue = tooltipView.layer.position.y
      $0.toValue = tooltipView.layer.position.y + tooltipView.bounds.height/2
      $0.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
      $0.duration = 0.56
    }
    
    tooltipView.layer.add(moveAnimation, forKey: nil)
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
      self.tooltipView.alpha = 0
    } completion: { _ in
      self.tooltipView.layer.removeAllAnimations()
      self.isAnimating = false
    }
    
  }
}

// MARK: - Helpers
extension PostDetailInputAccessoryWrapper {
  func configure(with profileImageURL: String?) {
    contentView.configure(with: profileImageURL)
  }
  
  func showKeyboard() {
    contentView.showKeyboard()
  }
  
  func hideKeyboard() {
    contentView.hideKeyboard()
  }
  
  func clearCommentInputState() {
    contentView.clearCommentInputState()
  }
  
  func setCommentForEditMode(_ text: String) {
    contentView.setCommentForEditMode(text)
  }
  
  func clearEditingText() {
    contentView.clearEditingText()
  }
}

// MARK: - UITextViewDelegate
extension PostDetailInputAccessoryWrapper: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    textView.resignFirstResponder()
  }
}

// MARK: - BaseProfileAreaViewDelegate
extension PostDetailInputAccessoryWrapper: BaseProfileAreaViewDelegate {
  func baseLeftRoundProfileAreaView(
    _ view: BaseProfileAreaView,
    didSelectProfileImage image: UIImage?
  ) {
    print("프로필 클릭")
  }
}

// MARK: - CommentInputViewDelegate
extension PostDetailInputAccessoryWrapper: CommentInputViewDelegate {
  func didTapSendIcon(_ text: String) {
    delegate?.didTouchSendIcon(text)
  }
}

// MARK: - LayoutSupport
extension PostDetailInputAccessoryWrapper: LayoutSupport {
  func addSubviews() {
    [tooltipView, contentView].forEach { addSubview($0) }
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
      contentView.bottomAnchor.constraint(
        equalTo: layoutMarginsGuide.bottomAnchor,
        constant: -insets.bottom),
      tooltipView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
      tooltipView.bottomAnchor.constraint(equalTo: topAnchor, constant: -2)])
  }
}
