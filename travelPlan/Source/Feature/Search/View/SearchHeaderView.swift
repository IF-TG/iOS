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
    $0.font = UIFont(pretendard: .bold, size: 25)
    $0.textColor = .yg.gray7
    $0.numberOfLines = 1
    $0.textAlignment = .left
    $0.text = "베스트 축제" // will erase
  }
  
  private let lookingMoreButton: UIButton = .init().set {
    $0.setTitle("더보기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.setTitleColor(.yg.gray4, for: .normal)
    $0.setImage(UIImage(named: "plus"), for: .normal)
    $0.layer.cornerRadius = 12
    $0.layer.borderColor = UIColor.yg.gray0.cgColor
    $0.layer.borderWidth = 1
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
  func configure(_ headerTitle: String) {
    headerLabel.text = headerTitle
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
      $0.leading.equalToSuperview().inset(20)
      $0.trailing.lessThanOrEqualTo(lookingMoreButton.snp.leading).offset(-20)
      $0.top.equalToSuperview().inset(30)
      $0.bottom.equalToSuperview().inset(20)
    }
    
    lookingMoreButton.snp.makeConstraints {
      $0.top.equalTo(headerLabel)
      $0.width.equalTo(64)
      $0.height.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
}
