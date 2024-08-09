//
//  DestinationDetailServiceCell.swift
//  travelPlan
//
//  Created by SeokHyun on 11/29/23.
//

import UIKit
import SnapKit

struct DestinationDetailServiceTypeViewInfo {
  let imageName: String
  let title: String
}

class DestinationDetailServiceCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String(describing: DestinationDetailServiceCell.self)
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
extension DestinationDetailServiceCell: LayoutSupport {
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
extension DestinationDetailServiceCell {
  func configure(models: [DestinationDetailServiceTypeViewInfo]) {
    if !onceConfigure {
      for model in models {
        let serviceTypeView = DestinationDetailServiceTypeView(title: model.title, imageName: model.imageName)
        
        stackView.addArrangedSubview(serviceTypeView)
        serviceTypeView.snp.makeConstraints {
          $0.height.equalTo(91)
        }
      }
      onceConfigure = true
    }
  }
}
