//
//  FavoriteDetailCategoryView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

final class FavoriteDetailCategoryView: UIView {
  enum Constant {
    enum TravelReviewLabel {
      enum Spacing {
        static let leading: CGFloat = 16
        static let top = leading
        static let bottom = leading
      }
    }
    
    enum TravelLocationLabel {
      enum Spacing {
        static let leading: CGFloat = 8
        static let top: CGFloat = 16
        static let trailing: CGFloat = top
        static let bottom: CGFloat = top
      }
    }
  }
  
  // MARK: - Properties
  private var travelReviewLabel = PrimaryColorToneRoundLabel(currentState: .selected).set {
    $0.text = "여행 리뷰"
  }
  
  private var travelLocationLabel = PrimaryColorToneRoundLabel().set {
    $0.text = "장소"
  }
  
  var travelReviewTapHandler: (() -> Void)? {
    travelReviewLabel.tapHandler
  }
  
  var travelLocationTapHandler: (() -> Void)? {
    travelLocationLabel.tapHandler
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
  
  // MARK: - Private Helpers
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
}

// MARK: - LayoutSupport
extension FavoriteDetailCategoryView: LayoutSupport {
  func addSubviews() {
    _=[
      travelReviewLabel,
      travelLocationLabel
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      travelReviewLabelConstraints,
      travelLocationLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension FavoriteDetailCategoryView {
  var travelReviewLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TravelReviewLabel.Spacing
    return [
      travelReviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      travelReviewLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      travelReviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.bottom)]
  }
  
  var travelLocationLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TravelLocationLabel.Spacing
    return [
      travelLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.leading),
      travelLocationLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top),
      travelLocationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.bottom),
      travelLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Spacing.trailing)]
  }
  
}
