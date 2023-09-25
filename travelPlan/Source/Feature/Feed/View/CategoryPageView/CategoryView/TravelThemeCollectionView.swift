//
//  TravelThemeCollectionView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/26.
//

import UIKit

final class TravelThemeCollectionView: UICollectionView {
  static let id = String(describing: TravelThemeCollectionView.self)
  
  init(frame: CGRect) {
    let layout = UICollectionViewFlowLayout().set {
      $0.scrollDirection = .horizontal
      $0.itemSize = CategoryView.Constant.cellSize
      $0.minimumLineSpacing = 0
      $0.minimumInteritemSpacing = 0
    }
    super.init(frame: frame, collectionViewLayout: layout)
    decelerationRate = .fast
    showsHorizontalScrollIndicator = false
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
