//
//  PostFooterView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostFooterView: UIView {
  enum Constant {
    enum Heart {
      enum Text {
        static let font: UIFont = UIFont(pretendard: .regular_400(fontSize: 14))!
        static let fontColor: UIColor = .yg.gray4
        enum Spacing {
          static let leading: CGFloat = 5
        }
      }
      enum Icon {
        static let minimumsSize = CGSize(width: 17, height: 15)
        static let color: UIColor = .yg.red
        static let unselectedImage = UIImage(named: "unselectedHeart")?.setColor(color)
        static let selectedImage = UIImage(named: "selectedHeart")?.setColor(color)
        enum Spacing {
          static let leading: CGFloat = 11
        }
      }
    }
    enum Comment {
      enum Text {
        static let font: UIFont = UIFont(pretendard: .regular_400(fontSize: 14))!
        static let fontColor: UIColor = .yg.gray4
        enum Spacing {
          static let leading: CGFloat = 5
        }
      }
      enum Icon {
        static let name = "feedComment"
        static let minimumsSize = CGSize(width: 20, height: 20)
        enum Spacing {
          static let leading: CGFloat = 12.5
        }
      }
    }
    enum Share {
      static let iconName = "feedShare"
      static let height: CGFloat = 15
      static let width: CGFloat = 15
      enum Spacing {
        static let trailing: CGFloat = 11
      }
    }
  }

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
    typealias Const = Constant.Heart.Text
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "0"
    $0.textAlignment = .left
    $0.font = Const.font
    $0.textColor = Const.fontColor
  }
  
  private lazy var commentIcon = UIImageView().set {
    typealias Const = Constant.Comment.Icon
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: Const.name)?.setColor(.yg.gray4)
    $0.contentMode = .scaleAspectFit
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(didTapComment))
    $0.addGestureRecognizer(tap)
  }
  
  private let commentText = UILabel().set {
    typealias Const = Constant.Heart.Text
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "0"
    $0.textAlignment = .left
    $0.font = Const.font
    $0.textColor = Const.fontColor
  }
  
  private lazy var shareButton = UIButton().set {
    typealias Const = Constant.Share
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
    $0.setImage(UIImage(named: Const.iconName)?.setColor(.yg.gray4), for: .normal)
    var img = UIImage(named: Const.iconName)
    img = img?.setColor(.yg.gray4.withAlphaComponent(0.5))
    $0.setImage(img, for: .highlighted)
    $0.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
  }
  
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
    // TODO: - 하트 취소, 수락 서버 갱신. 여기선 서버로 하트 취소한거 처리 해야합니다
    updatePostHeartState()
    print("DEBUG: 찜")
  }
  
  @objc func didTapComment() {
    print("커맨드 화면 이동")
  }
  
  @objc func didTapShare() {
    print("share 화면으로 이동")
  }
}

// MARK: - Helper
extension PostFooterView {
  func configure(with data: PostFooterInfo?) {
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

// MARK: - Private helper
extension PostFooterView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
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
    _=[
      heartIcon,
      heartText,
      commentIcon,
      commentText,
      shareButton
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      heartIconConstraint,
      heartTextConstraint,
      commentIconConstraint,
      commentTextConstraint,
      shareIconConstraint
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension PostFooterView {
  typealias NSLayout = NSLayoutConstraint
  var heartIconConstraint: [NSLayout] {
    typealias Const = Constant.Heart.Icon
    typealias Spacing = Constant.Heart.Icon.Spacing
    return [
      heartIcon.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Spacing.leading),
      heartIcon.centerYAnchor.constraint(
        equalTo: centerYAnchor),
      heartIcon.widthAnchor.constraint(
        equalToConstant: Const.minimumsSize.width),
      heartIcon.heightAnchor.constraint(
        lessThanOrEqualToConstant: Const.minimumsSize.height)]
  }
  
  var heartTextConstraint: [NSLayout] {
    typealias Spacing = Constant.Heart.Text.Spacing
    return [
      heartText.leadingAnchor.constraint(
        equalTo: heartIcon.trailingAnchor,
        constant: Spacing.leading),
      heartText.centerYAnchor.constraint(
        equalTo: centerYAnchor)]
  }
  
  var commentIconConstraint: [NSLayout] {
    typealias Const = Constant.Comment.Icon
    typealias Spacing = Constant.Comment.Icon.Spacing
    return [
      commentIcon.leadingAnchor.constraint(
        equalTo: heartText.trailingAnchor,
        constant: Spacing.leading),
      commentIcon.centerYAnchor.constraint(
        equalTo: centerYAnchor),
      commentIcon.widthAnchor.constraint(
        equalToConstant: Const.minimumsSize.width),
      commentIcon.heightAnchor.constraint(
        lessThanOrEqualToConstant: Const.minimumsSize.height)]
  }
  
  var commentTextConstraint: [NSLayout] {
    typealias Spacing = Constant.Comment.Text.Spacing
    return [
      commentText.leadingAnchor.constraint(
        equalTo: commentIcon.trailingAnchor,
        constant: Spacing.leading),
      commentText.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var shareIconConstraint: [NSLayout] {
    typealias Spacing = Constant.Share.Spacing
    typealias Const = Constant.Share
    return [
      shareButton.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Spacing.trailing),
      shareButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: Const.height),
      shareButton.widthAnchor.constraint(equalToConstant: Const.width)]
  }
}
