//
//  PostView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostView: UICollectionView {
  // MARK: - Properties
  let layout = UICollectionViewFlowLayout()
  
  var vm: PostViewModel!
  
  // MARK: - Initialization
  private override init(
    frame: CGRect,
    collectionViewLayout layout: UICollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    self.register(PostCell.self,
                  forCellWithReuseIdentifier: PostCell.id)
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
    showsHorizontalScrollIndicator = false
    backgroundColor = .yg.gray00Background
    dataSource = self
    delegate = self
  }
}

// MARK: - UICollectionViewDataSource
extension PostView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return vm.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PostCell.id,
      for: indexPath
    ) as? PostCell else {
      return UICollectionViewCell()
    }
    cell.configure(with: vm.cellItem(indexPath))
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PostView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    sizeToFit()
    return vm.calculatePostCellWidthAndDynamicHeight(
      fromSuperView: collectionView,
      indexPath)
  }
}
