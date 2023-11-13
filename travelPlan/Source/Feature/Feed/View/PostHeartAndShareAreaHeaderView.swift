//
//  PostHeartAndShareAreaHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 11/13/23.
//

import UIKit

final class PostHeartAndShareAreaHeaderView: UITableViewHeaderFooterView {
  static let id = String(describing: PostHeartAndShareAreaHeaderView.self)
  
  // MARK: - Properties
  private var postHeartState: Bool? = false
  
  private let heartStackView = IconWithCountLabelStackView(
    iconInfo: .init(size: .init(width: 20, height: 20),
                    iconPath: "unselectedHeart"),
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: nil)
  ).set {
    $0.countLabel.textColor = .yg.gray4
    $0.countLabel.text = "0"
  }
  
  private let commentStackView = IconWithCountLabelStackView(
    iconInfo: .init(size: .init(width: 20, height: 20),
                    iconPath: "feedComment"),
    countInfo: .init(fontType: .regular_400(fontSize: 14), lineHeight: nil)
  ).set {
    $0.icon.image = $0.icon.image?.setColor(.yg.gray4)
    $0.countLabel.textColor = .yg.gray4
    $0.countLabel.text = "0"
  }
  
  private lazy var shareButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    let image = UIImage(named: "feedShare")
    $0.setImage(image?.setColor(.yg.gray4), for: .normal)
    $0.setImage(image?.setColor(.yg.gray4.withAlphaComponent(0.5)), for: .highlighted)
    $0.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
  }
  
  private lazy var postOptionIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    let image = UIImage(named: "feedOption")
    $0.image = image
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOption))
    $0.addGestureRecognizer(tap)
    
  }
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension PostHeartAndShareAreaHeaderView {
  func configure(with info: PostFooterInfo?) {
    heartStackView.setCountLabel(text: info?.heartCount)
    commentStackView.setCountLabel(text: info?.commentCount)
    setHeartIcon(with: info?.heartState ?? false)
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

// MARK: - Private Helpers
extension PostHeartAndShareAreaHeaderView {
  private func configureUI() {
    setupUI()
    setCommentIconTapGesture()
    setHeartIconTapGesture()
  }
  
  private func setCommentIconTapGesture() {
    commentStackView.icon.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapComment))
    commentStackView.icon.addGestureRecognizer(tap)
  }
  
  private func setHeartIconTapGesture() {
    heartStackView.icon.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeart))
    heartStackView.icon.addGestureRecognizer(tap)
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

// MARK: - Actions
private extension PostHeartAndShareAreaHeaderView {
  @objc func didTapHeart() {
    updatePostHeartState()
    print("DEBUG: 찜")
  }
  
  @objc func didTapComment() {
    print("커맨드 화면 이동")
  }
  
  @objc func didTapShare() {
    print("share 화면으로 이동")
  }
  
  @objc func didTapOption() {
    print("option 화면으로 이동")
  }
}

// MARK: - LayoutSupport
extension PostHeartAndShareAreaHeaderView: LayoutSupport {
  func addSubviews() {
    [heartStackView, 
     commentStackView,
     shareButton,
     postOptionIcon
    ].forEach { addSubview($0) }
  }
  
  func setConstraints() {
    [heartStackViewConstraints,
     commentStackViewConstriants,
     shareIconConstraints,
     postOptionIconConstraints].forEach { NSLayoutConstraint.activate($0) }
  }
  
  private var heartStackViewConstraints: [NSLayoutConstraint] {
    return [
      heartStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
      heartStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      heartStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)]
  }
  
  private var commentStackViewConstriants: [NSLayoutConstraint] {
    return [
      commentStackView.leadingAnchor.constraint( equalTo: heartStackView.trailingAnchor, constant: 12.5),
      commentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  private var shareIconConstraints: [NSLayoutConstraint] {
    return [
      shareButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 18),
      shareButton.widthAnchor.constraint(equalToConstant: 18)]
  }

  private var postOptionIconConstraints: [NSLayoutConstraint] {
    return [
      postOptionIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
      postOptionIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
      postOptionIcon.widthAnchor.constraint(equalToConstant: 24),
      postOptionIcon.heightAnchor.constraint(equalToConstant: 18),
      postOptionIcon.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 20)]
  }
}
