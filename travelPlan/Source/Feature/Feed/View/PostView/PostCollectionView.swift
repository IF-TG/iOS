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
      static var estimatedCellHeight: CGFloat {
        PostCell.Constant.maximumHeight
      }
      static let groupInset: NSDirectionalEdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    }
    static let backgroundColor: UIColor = .yg.gray00Background
  }
  
  // MARK: - Properties
  private(set) var sectionIndex = 0
  
  // MARK: - Lifecycle
  init(frame: CGRect, layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    configureUI()
  }
  
  init(frame: CGRect) {
    super.init(frame: frame, collectionViewLayout: .init())
    collectionViewLayout = makePostLayout()
    configureUI()
  }
  
  init(layout: UICollectionViewLayout) {
    super.init(frame: .zero, collectionViewLayout: layout)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    collectionViewLayout = makePostLayout()
  }
}

// MARK: - Private helpers
extension PostCollectionView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    showsHorizontalScrollIndicator = false
    backgroundColor = Constant.backgroundColor
    register(
      PostCell.self,
      forCellWithReuseIdentifier: PostCell.id)
  }
  
  private func makePostLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
      guard sectionIndex == (self?.sectionIndex ?? 0) else { return nil }
      return self?.postSection
    }.set {
      $0.register(
        InnerRoundRectReusableView.self,
        forDecorationViewOfKind: InnerRoundRectReusableView.id)
    }
  }
  
  private var postSection: NSCollectionLayoutSection {
    typealias LayoutSize = NSCollectionLayoutSize
    typealias Const = Constant.Layout
    let groupHeight = Const.estimatedCellHeight
    let itemSize = LayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(groupHeight))
    let groupSize = LayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(groupHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    return NSCollectionLayoutSection(group: group).set {
      let whiteRoundView = NSCollectionLayoutDecorationItem.background(elementKind: InnerRoundRectReusableView.id)
      $0.contentInsets = Const.groupInset
      whiteRoundView.contentInsets = Const.groupInset
      $0.decorationItems = [whiteRoundView]
    }
  }
}
