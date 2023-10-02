//
//  CategoryDetailView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit
import Combine

/// DetailViewCell은 포스트 컬랙션 뷰를 갖습니다. 그리고 포스트 컬랙션 뷰는 사용자가 올린 포스트들을 아래 스크롤로 보여줍니다.
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
      if bounds.height != 0, !isSetItemSize, let layout = collectionViewLayout as? UICollectionViewFlowLayout {
        isSetItemSize.toggle()
        layout.itemSize = bounds.size
      }
    }
  }
  
  // MARK: - Lifecycle
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
      $0.itemSize = CGSize(width: 100, height: 100)
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
