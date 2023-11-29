//
//  SearchDestinationServiceCell.swift
//  travelPlan
//
//  Created by SeokHyun on 11/29/23.
//

import UIKit
import SnapKit

class SearchDestinationServiceCell: UICollectionViewCell {
  // MARK: - Properties
  private let stackView = UIStackView().set {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fillEqually
    $0.spacing = 20
  }
  
  private let titleLabel = UILabel().set {
    $0.text = "제목"
    $0.font = .init(pretendard: .medium_500(fontSize: 12))
    $0.textColor = .yg.gray6
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension SearchDestinationServiceCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(stackView)
  }
  
  func setConstraints() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
