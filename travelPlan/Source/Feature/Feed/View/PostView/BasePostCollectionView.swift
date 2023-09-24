//
//  BasePostCollectionView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class BasePostCollectionView: UICollectionView {
  enum Constants {
    enum Layout {
      static let estimatedCellHeight: CGFloat = 289
      static let groupInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
    }
  }
  
  // MARK: - Properties
  private var baseViewModel: PostViewModel
  
  private var baseAdapter: PostViewAdapter
  
  // MARK: - Initialization
  init(frame: CGRect, layout: UICollectionViewLayout, vm: PostViewModel, adapter: PostViewAdapter) {
    self.baseViewModel = vm
    self.baseAdapter = adapter
    super.init(frame: frame, collectionViewLayout: layout)
    register(
      PostCell.self,
      forCellWithReuseIdentifier: PostCell.id)
    showsHorizontalScrollIndicator = false
    backgroundColor = .clear
  }
  
  convenience init(layout: UICollectionViewLayout, vm: PostViewModel, adapter: PostViewAdapter) {
    self.init(frame: .zero, layout: layout, vm: vm, adapter: adapter)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  convenience init(vm: PostViewModel, adapter: PostViewAdapter) {
    self.init(layout: .init(), vm: vm, adapter: adapter)
    collectionViewLayout = makeLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Private func
  private func makeLayout() -> UICollectionViewLayout {
    typealias LayoutSize = NSCollectionLayoutSize
    typealias Const = Constants.Layout
    let itemSize = LayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let groupSize = LayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Const.estimatedCellHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup(layoutSize: groupSize)
    let section = makeLayoutSection(from: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func makeLayoutSection(from group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
    typealias Const = Constants.Layout
    return NSCollectionLayoutSection(group: group).set {
      $0.contentInsets = Const.groupInset
    }
  }
}
