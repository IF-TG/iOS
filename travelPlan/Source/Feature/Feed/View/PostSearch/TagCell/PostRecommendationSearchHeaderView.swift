//
//  PostRecommendationSearchHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/31.
//

import UIKit
import SnapKit

final class PostRecommendationSearchHeaderView: UICollectionReusableView {
  enum Constants {
    enum TitleLabel {
      static let fontSize: CGFloat = 17
    }
  }
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let titleLabel: UILabel = .init().set {
    $0.font = .init(pretendard: .bold, size: Constants.TitleLabel.fontSize)
    $0.textColor = .yg.gray6
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    prepare(title: nil)
  }
}

// MARK: - Public Helpers
extension PostRecommendationSearchHeaderView {
  func prepare(title: String?) {
    titleLabel.text = title
  }
}

// MARK: - LayoutSupport
extension PostRecommendationSearchHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(titleLabel)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
}
