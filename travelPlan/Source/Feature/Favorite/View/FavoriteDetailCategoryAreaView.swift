//
//  FavoriteDetailCategoryAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

final class FavoriteDetailCategoryAreaView: UIView {
  enum Constant {
    enum CategoryStackView {
      static let height: CGFloat = 40
      static let interItemSpacing: CGFloat = 8
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 16
        static let trailing = leading
      }
    }
        
    enum StoredTotalPostLabel {
      static let textColor: UIColor = .YG.gray3
      static let textSize: CGFloat = 13
      static let textWeight: CGFloat = 500
      enum Spacing {
        static let top: CGFloat = 16
        static let leaidng: CGFloat = 20
        static let trailing = leaidng
      }
    }
  }
  
  // MARK: - Properties
  private lazy var categoryStackView = UIStackView(arrangedSubviews: [travelReviewLabel, travelLocationLabel]).set {
    typealias Const = Constant.CategoryStackView
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = Const.interItemSpacing
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  private let travelReviewLabel = PrimaryColorToneRoundLabel(currentState: .selected).set {
    $0.text = "여행 리뷰"
  }
  
  private let travelLocationLabel = PrimaryColorToneRoundLabel().set {
    $0.text = "장소"
  }
  
  // TODO: - 이건 트래벌 리뷰 눌르면 그때 하위 뷰컨에서 얼마나 컨텐츠 보유중인지 확인 후 다시 여기에 새로 갱신해야할거같음.
  private var storedPostCount: Int = 0
  
  private lazy var storedTotalPostLabel: UILabel = UILabel(frame: .zero).set {
    typealias Const = Constant.StoredTotalPostLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.textAlignment = .natural
    $0.textColor = Const.textColor
    $0.font = UIFont.systemFont(ofSize: Const.textSize, weight: .init(Const.textWeight))
    $0.text = "찜한 글 " + storedPostCount.zeroPaddingString + "개"
    $0.sizeToFit()
  }
  
  var travelReviewTapHandler: (() -> Void)? {
    travelReviewLabel.tapHandler
  }
  
  // TODO: - 나중에 이거 Void반환말고 Int로 반환해서 그 특정 메뉴에 찜 몇개인지 판단하고 그거에 따라 빈화면인지 아닌지 구분해야함.
  var travelLocationTapHandler: (() -> Void)? {
    travelLocationLabel.tapHandler
  }
  
  override var intrinsicContentSize: CGSize {
    let width = super.intrinsicContentSize.width
    let height = 98.0
    return .init(width: width, height: height)
  }
  
  // MARK: - Lifecycle
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

// MARK: - Helpers
extension FavoriteDetailCategoryAreaView {
  func plusStoredPost() {
    storedPostCount += 1
  }
  
  func minusStoredPost() -> Bool {
    if storedPostCount == 0 {
      return false
    }
    storedPostCount -= 1
    return true
  }
}

// MARK: - Private Helpers
extension FavoriteDetailCategoryAreaView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
}

// MARK: - LayoutSupport
extension FavoriteDetailCategoryAreaView: LayoutSupport {
  func addSubviews() {
    _=[
      categoryStackView,
      storedTotalPostLabel
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      categoryStackViewConstraints,
      storedTotalPostLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension FavoriteDetailCategoryAreaView {
  var categoryStackViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CategoryStackView
    typealias Spacing = Const.Spacing
    return [
      categoryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      categoryStackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      categoryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      categoryStackView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var storedTotalPostLabelConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.StoredTotalPostLabel
    typealias Spacing = Const.Spacing
    return [
      storedTotalPostLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leaidng),
      storedTotalPostLabel.topAnchor.constraint(equalTo: travelReviewLabel.bottomAnchor, constant: Spacing.top),
      storedTotalPostLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing)]
  }
}
