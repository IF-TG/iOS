//
//  ReviewWritingThemeDescriptionHeader.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit

final class ReviewWritingThemeDescriptionHeader: UICollectionReusableView {
  static let id = String(describing: ReviewWritingThemeDescriptionHeader.self)
  
  // MARK: - Properties
  private let title = BaseLabel.init(fontType: .semiBold_600(fontSize: 18)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.text = "내 여행에 맞는\n테마를 찾아보세요!"
    let lightFontInfo = HighlightFontInfo(
      fontType: .semiBold_600(fontSize: 18),
      text: "내 여행",
      additionalAttributes: [.foregroundColor: UIColor.yg.primary.cgColor])
    $0.setHighlight(with: lightFontInfo)
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) { nil }
}

// MARK: - LayoutSupport
extension ReviewWritingThemeDescriptionHeader: LayoutSupport {
  func addSubviews() {
    addSubview(title)
  }

  func setConstraints() {
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)])
  }
}
