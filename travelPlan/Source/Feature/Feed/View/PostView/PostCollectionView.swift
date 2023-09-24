//
//  PostCollectionView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

class PostCollectionView: UICollectionView {
  enum Constants {
    enum Layout {
      static let estimatedCellHeight: CGFloat = 289
      static let groupInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
    }
    static let backgroundColor: UIColor = .yg.gray00Background
  }
  
  // MARK: - Properties
  private var postViewModel: PostViewModel
  
  private(set) var sectionIndex = 0
  
  // MARK: - Initialization
  init(frame: CGRect, layout: UICollectionViewLayout, viewModel: PostViewModel) {
    self.postViewModel = viewModel
    super.init(frame: frame, collectionViewLayout: layout)
    configureUI()
  }
  
  init(frame: CGRect, viewModel: PostViewModel) {
    postViewModel = viewModel
    super.init(frame: frame, collectionViewLayout: .init())
    collectionViewLayout = makePostLayout()
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
    postViewModel = .init(data: [.init(header: .init(), content: .init(), footer: .init())])
    super.init(coder: coder)
    configureUI()
    collectionViewLayout = makePostLayout()
  }
  
  // MARK: - Helper
  func configure(with data: [PostModel]) {
    postViewModel = .init(data: data)
  }
 
  // MARK: - Private helper
  private func configureUI() {
    showsHorizontalScrollIndicator = false
    backgroundColor = Constants.backgroundColor
    register(
      PostCell.self,
      forCellWithReuseIdentifier: PostCell.id)
  }
  
  func makePostLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
      guard sectionIndex == (self?.sectionIndex ?? 0) else { return nil }
      return self?.postSection
    }.set {
      $0.register(
        RoundReusableView.self,
        forDecorationViewOfKind: RoundReusableView.id)
    }
  }
  
  private var postSection: NSCollectionLayoutSection {
    typealias LayoutSize = NSCollectionLayoutSize
    typealias Const = Constants.Layout
    let itemSize = LayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1))
    let groupSize = LayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(Const.estimatedCellHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    return NSCollectionLayoutSection(group: group).set {
      let whiteRoundView = NSCollectionLayoutDecorationItem.background(elementKind: RoundReusableView.id)
      $0.contentInsets = Const.groupInset
      $0.orthogonalScrollingBehavior = .groupPaging
      $0.decorationItems = [whiteRoundView]
    }
  }
}
