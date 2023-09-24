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
  
  // MARK: - Initialization
  init(frame: CGRect, layout: UICollectionViewLayout, viewModel: PostViewModel) {
    self.baseViewModel = viewModel
    super.init(frame: frame, collectionViewLayout: layout)
    configureUI()
  }
  
  init(frame: CGRect, viewModel: PostViewModel) {
    baseViewModel = viewModel
    super.init(frame: frame, collectionViewLayout: .init())
    collectionViewLayout = makeLayout()
    configureUI()
  }
  
  convenience init(layout: UICollectionViewLayout, viewModel: PostViewModel) {
    self.init(frame: .zero, layout: layout, viewModel: viewModel)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  convenience init(viewModel: PostViewModel) {
    self.init(frame: .zero, viewModel: viewModel)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    collectionViewLayout = makeLayout()
  }
  
  // MARK: - Private func
  private func configureUI() {
    showsHorizontalScrollIndicator = false
    backgroundColor = .clear
    register(
      PostCell.self,
      forCellWithReuseIdentifier: PostCell.id)
  }
  
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
