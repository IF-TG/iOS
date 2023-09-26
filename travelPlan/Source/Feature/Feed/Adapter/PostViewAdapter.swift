//
//  PostViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

protocol PostViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  var travelTheme: TravelMainThemeType { get }
  var travelTrend: TravelOrderType { get }
  
  func postViewCellItem(at index: Int) -> PostModel
  func contentText(at index: Int) -> String
}

final class PostViewAdapter: NSObject {
  weak var dataSource: PostViewAdapterDataSource?
  init(
    dataSource: PostViewAdapterDataSource? = nil,
    collectionView: PostCollectionView?
  ) {
    super.init()
    self.dataSource = dataSource
    collectionView?.dataSource = self
  }
}

// MARK: - UICollectionViewDataSource
extension PostViewAdapter: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView, 
    numberOfItemsInSection section: Int
  ) -> Int {
    if section == 0 {
      return dataSource?.numberOfItems ?? 0
    }
    return 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    if indexPath.section == 0 {
      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCell.id,
          for: indexPath
        ) as? PostCell,
        let dataSource = dataSource
      else {
        return .init(frame: .zero)
      }
      cell.configure(with: dataSource.postViewCellItem(at: indexPath.row))
      return cell
    }
    return .init(frame: .zero)
  }
}
