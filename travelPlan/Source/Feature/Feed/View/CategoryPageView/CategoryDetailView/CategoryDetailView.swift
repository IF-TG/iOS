//
//  CategoryDetailView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit
import Combine

final class CategoryDetailView: UICollectionView {
  // MARK: - Properties
  @Published private var isSetItemSize = false
  
  var itemSizeSetNotifier: AnyPublisher<Void, Never> {
    $isSetItemSize
      .filter { $0 }
      .map { _ -> Void in }
      .eraseToAnyPublisher()
  }
  
  override var bounds: CGRect {
    didSet {
      if !isSetItemSize,
         let layout = collectionViewLayout as? UICollectionViewFlowLayout
      {
        isSetItemSize.toggle()
        layout.itemSize = bounds.size
      }
    }
  }
  
  // MARK: - Initialization
  override init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    showsHorizontalScrollIndicator = false
    decelerationRate = .fast
    isScrollEnabled = false
    register(
      CategoryDetailViewCell.self,
      forCellWithReuseIdentifier: CategoryDetailViewCell.id)
  }
  
  convenience init() {
    let layout = UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 0
      $0.scrollDirection = .horizontal
      $0.itemSize = CGSize(width: 50, height: 50)
    }
    self.init(
      frame: .zero,
      collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
