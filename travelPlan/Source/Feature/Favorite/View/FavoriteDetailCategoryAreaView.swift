//
//  FavoriteDetailCategoryAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

final class FavoriteDetailCategoryAreaView: UIView {
  enum Constant {
    enum TravelReviewLabel {
      static let height: CGFloat = 40
      enum Spacing {
        static let leading: CGFloat = 16
        static let top = leading
      }
    }
    
    enum TravelLocationLabel {
      static let height: CGFloat = 40
      enum Spacing {
        static let leading: CGFloat = 8
        static let top: CGFloat = 16
        static let trailing: CGFloat = top
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
  private let travelReviewLabel = PrimaryColorToneRoundLabel(currentState: .selected).set {
    $0.text = "여행 리뷰"
  }
  
  private let travelLocationLabel = PrimaryColorToneRoundLabel().set {
    $0.text = "장소"
  }
  
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
      travelReviewLabel,
      travelLocationLabel,
      storedTotalPostLabel
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      travelReviewLabelConstraints,
      travelLocationLabelConstraints,
      storedTotalPostLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension FavoriteDetailCategoryAreaView {
  var travelReviewLabelConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TravelReviewLabel
    typealias Spacing = Const.Spacing
    return [
      travelReviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      travelReviewLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      travelReviewLabel.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var travelLocationLabelConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TravelLocationLabel
    typealias Spacing = Const.Spacing
    return [
      travelLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      travelLocationLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      travelLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.trailing),
      travelLocationLabel.heightAnchor.constraint(equalToConstant: Const.height)]
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
