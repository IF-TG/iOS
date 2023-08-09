//
//  SearchHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/30.
//

import UIKit
import SnapKit

final class SearchHeaderView: UICollectionReusableView {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let headerLabel: UILabel = UILabel().set {
    $0.font = UIFont(pretendard: .bold, size: Constants.HeaderLabel.fontSize)
    $0.textColor = .yg.gray7
    $0.numberOfLines = Constants.HeaderLabel.numberOfLines
    $0.textAlignment = .left
    $0.text = "베스트 축제"
  }
  
  private let lookingMoreButton: UIButton = .init().set {
    $0.setTitle(Constants.LookingMoreButton.title, for: .normal)
    $0.titleLabel?.font = .systemFont(
      ofSize: Constants.LookingMoreButton.titleFontSize,
      weight: .semibold
    )
    $0.setTitleColor(.yg.gray4, for: .normal)
    $0.setImage(UIImage(named: Constants.LookingMoreButton.imageName), for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.layer.cornerRadius = Constants.LookingMoreButton.cornerRadius
    $0.layer.borderColor = UIColor.yg.gray0.cgColor
    $0.layer.borderWidth = Constants.LookingMoreButton.borderWidth
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public Helpers
extension SearchHeaderView {
  func configure(header: SearchHeaderModel) {
    headerLabel.text = header.title
  }
}

// MARK: - LayoutSupport
extension SearchHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(headerLabel)
    addSubview(lookingMoreButton)
  }
  
  func setConstraints() {
    headerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(Constants.HeaderLabel.Inset.leading)
      $0.trailing.lessThanOrEqualTo(lookingMoreButton.snp.leading)
        .offset(Constants.HeaderLabel.Offset.trailing)
      $0.top.equalToSuperview().inset(Constants.HeaderLabel.Inset.top)
      $0.bottom.equalToSuperview().inset(Constants.HeaderLabel.Inset.bottom)
    }
    
    lookingMoreButton.snp.makeConstraints {
      $0.top.equalTo(headerLabel)
      $0.width.equalTo(Constants.LookingMoreButton.width)
      $0.height.equalTo(Constants.LookingMoreButton.height)
      $0.trailing.equalToSuperview()
        .inset(Constants.LookingMoreButton.Inset.trailing)
    }
  }
}
