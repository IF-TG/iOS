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
  
  private let heartStackView = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 20, height: 20),
                    iconPath: "unselectedHeart"), 
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: nil)
  ).set {
    $0.label.textColor = .yg.gray4
      $0.label.text = "0"
    }
  
  private let commentStackView = IconWithLabelStackView(
    iconInfo: .init(size: .init(width: 20, height: 20),
                    iconPath: "feedComment"),
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: nil)
  ).set {
    $0.icon.image = $0.icon.image?.setColor(.yg.gray4)
    $0.label.textColor = .yg.gray4
    $0.label.text = "0"
  }
  
  private lazy var shareButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    let image = UIImage(named: "feedShare")
    $0.setImage(image?.setColor(.yg.gray4), for: .normal)
    $0.setImage(image?.setColor(.yg.gray4.withAlphaComponent(0.5)), for: .highlighted)
    $0.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
  }
  
  weak var delegate: PostFooterViewDelegate?
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Action
private extension PostFooterView {
  @objc func didTapHeart() {
    updatePostHeartState()
    delegate?.didTapHeart()
  }
  
  @objc func didTapComment() {
    delegate?.didTapComment()
  }
  
  @objc func didTapShare() {
    delegate?.didTapShare()
  }
}

// MARK: - Helper
extension PostFooterView {
  func configure(with data: PostFooterInfo?) {
    setHeart(with: data?.heartCount)
    setHeartIcon(with: data?.heartState ?? false)
    setComment(with: data?.commentCount)
  }
  
  func updatePostHeartState() {
    /// 여기서 서버 포스트에 대한 로그인 사용자 포스트 상태 관련 처리
    // TODO: - 개수도 증가해야함.
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

// MARK: - Private helper
extension PostFooterView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    setCommentIconTapGesture()
    setHeartIconTapGesture()
  }
  
  private func setCommentIconTapGesture() {
    commentStackView.icon.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapComment))
    commentStackView.icon.addGestureRecognizer(tap)
  }
  
  private func setHeartIconTapGesture() {
    heartStackView.icon.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapHeart))
    heartStackView.icon.addGestureRecognizer(tap)
  }
  
  private func setHeart(with text: String?) {
    heartStackView.label.text = text
  }
  
  private func setComment(with text: String?) {
    commentStackView.label.text = text
  }

  private func setHeartIcon(with state: Bool) {
    postHeartState = state
    if state {
      heartStackView.icon.image = UIImage(named: "selectedHeart")?.setColor(.yg.red)
    } else {
      // 하트 취소
      heartStackView.icon.image = UIImage(named: "unselectedHeart")?.setColor(.yg.red)
    }
  }
  
  private func selectedHeartAnim() {
    heartStackView.icon.alpha = 0.0
    heartStackView.icon.transform = CGAffineTransform(scaleX: 0, y: 0)
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      options: .curveEaseInOut) {
        self.heartStackView.icon.alpha = 1.0
        self.heartStackView.icon.transform = CGAffineTransform(scaleX: 1, y: 1)
      }
  }
  private func unselectedHeartAnim() {
    heartStackView.icon.alpha = 0.0
    UIView.animate(
      withDuration: 0.4,
      delay: 0,
      options: .curveEaseOut) {
        self.heartStackView.icon.alpha = 1.0
    }
  }
}

// MARK: - LayoutSupport
extension PostFooterView: LayoutSupport {
  func addSubviews() {
    _=[
      heartStackView,
      commentStackView,
      shareButton
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      heartStackViewConstraint,
      commentStackViewConstriant,
      shareIconConstraint
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostFooterView {
  typealias NSLayout = NSLayoutConstraint
  var heartStackViewConstraint: [NSLayout] {
    return [
      heartStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
      heartStackView.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var commentStackViewConstriant: [NSLayout] {
    return [
      commentStackView.leadingAnchor.constraint( equalTo: heartStackView.trailingAnchor, constant: 12.5),
      commentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var shareIconConstraint: [NSLayout] {
    return [
      shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13.5),
      shareButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 15),
      shareButton.widthAnchor.constraint(equalToConstant: 15)]
  }
}
