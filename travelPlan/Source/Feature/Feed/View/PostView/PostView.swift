//
//  PostView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

// 07.04TODO: - post header 터치까지 구현해서 Feed vc에서 catch만함. 이제 bottom sheet만들어야하고, idx 0인 경우 숨겨야한다.

class PostView: UICollectionView {
  // MARK: - Properties
  let layout = UICollectionViewFlowLayout()
  
  var vm: PostViewModel!
  
  var adapter: PostViewAdapter!
  
  // MARK: - Initialization
  private override init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    register(
      PostCell.self,
                  forCellWithReuseIdentifier: PostCell.id)
    register(
      PostViewHeaderCategoryView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostViewHeaderCategoryView.id)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(with viewModel: PostViewModel) {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    self.init(frame: .zero, collectionViewLayout: layout)
    vm = viewModel
    self.adapter = PostViewAdapter(
      dataSource: vm,
      collectionView: self)
    showsHorizontalScrollIndicator = false
    backgroundColor = .yg.gray00Background
  }
}

extension PostView: MoreCategoryViewDelegate {
  func moreCategoryView(
    _ moreCategoryView: MoreCategoryView,
    didSelectedType type: TravelCategorySortingType
  ) {
    let data: [Notification.Name: TravelCategorySortingType] = [.TravelCategoryDetailSelected: type]
    NotificationCenter.default.post(
      name: .TravelCategoryDetailSelected,
      object: nil,
      userInfo: data)
  }
}
