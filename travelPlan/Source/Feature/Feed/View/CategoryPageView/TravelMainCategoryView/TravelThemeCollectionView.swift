//
//  TravelMainThemeCollectionView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/26.
//

import UIKit

final class TravelMainThemeCollectionView: UICollectionView {
  static let id = String(describing: TravelMainThemeCollectionView.self)
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    let layout = UICollectionViewFlowLayout().set {
      $0.scrollDirection = .horizontal
      $0.itemSize = TravelMainThemeCategoryAreaView.Constant.cellSize
      $0.minimumLineSpacing = 0
      $0.minimumInteritemSpacing = 0
    }
    super.init(frame: frame, collectionViewLayout: layout)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  // MARK: - Private helpers
  private func configureUI() {
    decelerationRate = .fast
    showsHorizontalScrollIndicator = false
    bounces = false
    register(
      TravelMainCategoryViewCell.self,
      forCellWithReuseIdentifier: TravelMainCategoryViewCell.id)
  }
}
