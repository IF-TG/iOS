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
    $0.text = "베스트 축제"
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

// MARK: - LayoutSupport
extension SearchHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(headerLabel)
  }
  
  func setConstraints() {
    headerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(20)
      $0.top.equalToSuperview().inset(30)
      $0.bottom.equalToSuperview().inset(20)
    }
  }
}
