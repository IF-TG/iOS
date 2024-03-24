//
//  PostCollectionView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit
import Combine

class PostCollectionView: UICollectionView {
  enum Constant {
    enum Layout {
      static let estimatedCellHeight: CGFloat = 289 - 33.42
      static let groupInset: NSDirectionalEdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    }
    static let backgroundColor: UIColor = .yg.gray00Background
  }
  
  // MARK: - Lifecycle
  init(frame: CGRect, layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    configureUI()
  }
  
  init(frame: CGRect) {
    super.init(frame: frame, collectionViewLayout: .init())
    collectionViewLayout = makeLayout()
    configureUI()
  }
  
  init(layout: UICollectionViewLayout) {
    super.init(frame: .zero, collectionViewLayout: layout)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    collectionViewLayout = makeLayout()
  }
}

// MARK: - Public Helpers
extension PostCollectionView {
  func makeLayout(withCustomSection customSection: NSCollectionLayoutSection? = nil) -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
      let section = PostViewSection(rawValue: sectionIndex)
      switch section {
      case .category:
        return customSection ?? self?.tempSection
      case .post:
        return self?.postSection
      case .bottomRefresh:
        return self?.refreshSection
      default:
        return nil
      }
    }.set {
      $0.register(
        InnerRoundRectReusableView.self,
        forDecorationViewOfKind: InnerRoundRectReusableView.baseID)
    }
  }
  
  var tempSection: NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(1), heightDimension: .absolute(0.1)))
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(widthDimension: .absolute(1), heightDimension: .absolute(0.1)),
      subitems: [item])
    return NSCollectionLayoutSection(group: group)
  }
  
  var refreshSection: NSCollectionLayoutSection {
    let size = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(45))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
    return NSCollectionLayoutSection(group: group)
  }
  
  var postSection: NSCollectionLayoutSection {
    typealias LayoutSize = NSCollectionLayoutSize
    typealias Const = Constant.Layout
    let groupHeight = Const.estimatedCellHeight
    let itemSize = LayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(groupHeight))
    let groupSize = LayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(groupHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    return NSCollectionLayoutSection(group: group).set {
      let whiteRoundView = NSCollectionLayoutDecorationItem.background(elementKind: InnerRoundRectReusableView.baseID)
      $0.contentInsets = Const.groupInset
      whiteRoundView.contentInsets = Const.groupInset
      $0.decorationItems = [whiteRoundView]
    }
  }
}

// MARK: - Private helpers
extension PostCollectionView {
  private func configureUI() {
    showsHorizontalScrollIndicator = false
    backgroundColor = Constant.backgroundColor
    register(PostCellWithOneThumbnail.self, forCellWithReuseIdentifier: PostCellWithOneThumbnail.id)
    register(PostCellWithTwoThumbnails.self, forCellWithReuseIdentifier: PostCellWithTwoThumbnails.id)
    register(PostCellWithThreeThumbnails.self, forCellWithReuseIdentifier: PostCellWithThreeThumbnails.id)
    register(PostCellWithFourThumbnails.self, forCellWithReuseIdentifier: PostCellWithFourThumbnails.id)
    register(PostCellWithFiveThumbnails.self, forCellWithReuseIdentifier: PostCellWithFiveThumbnails.id)
    let nextPageCellNib = UINib(nibName: "BottomNextPageIndicatorCell", bundle: nil)
    register(nextPageCellNib, forCellWithReuseIdentifier: BottomNextPageIndicatorCell.identifier)
  }
}
