//
//  SearchDestinationServiceCell.swift
//  travelPlan
//
//  Created by SeokHyun on 11/29/23.
//

import UIKit
import SnapKit

struct SearchDestinationServiceTypeViewInfo {
  let imageName: String
  let title: String
}

class SearchDestinationServiceCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String(describing: SearchDestinationServiceCell.self)
  private var onceConfigure = false
  private let stackView = UIStackView().set {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
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

// MARK: - Helpers
extension SearchDestinationServiceCell {
  func configure(models: [SearchDestinationServiceTypeViewInfo]) {
    if !onceConfigure {
      for model in models {
        let serviceTypeView = SearchDestinationServiceTypeView(title: model.title, imageName: model.imageName)
        
        stackView.addArrangedSubview(serviceTypeView)
        serviceTypeView.snp.makeConstraints {
          $0.height.equalTo(91)
        }
      }
      onceConfigure = true
    }
  }
}
