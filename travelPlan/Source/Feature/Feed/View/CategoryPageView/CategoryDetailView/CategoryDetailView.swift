//
//  CategoryDetailView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class CategoryDetailView: UICollectionView {
  // MARK: - Properties
  /// CategoryView가 로드된 후 height가 지정되면 detailView cell의 height지정하기 위해
  private var layout: UICollectionViewFlowLayout!
  
  // MARK: - Initialization
  convenience init() {
    let layoutObject = UICollectionViewFlowLayout()
    layoutObject.minimumLineSpacing = 0
    layoutObject.scrollDirection = .horizontal
    self.init(
      frame: .zero,
      collectionViewLayout: layoutObject)
    layout = layoutObject
  }
  
  private override init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    showsHorizontalScrollIndicator = false
    decelerationRate = .fast
    register(
      CategoryDetailViewCell.self,
      forCellWithReuseIdentifier: CategoryDetailViewCell.id)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension CategoryDetailView {
  func setLayoutItemSize(_ size: CGSize) {
    layout.itemSize = size
  }
}
