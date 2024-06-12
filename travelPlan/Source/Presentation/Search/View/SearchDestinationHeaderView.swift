//
//  SearchDestinationHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 6/12/24.
//

import UIKit
import SnapKit

final class SearchDestinationHeaderView: UICollectionReusableView {
  // MARK: - Properties
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: self.makeCompositionalLayout()
  ).set {
    $0.register(type: SearchDestinationImageCell.self)
    $0.contentInsetAdjustmentBehavior = .never
    $0.dataSource = self
  }
  
  private var dataSource = [Data]()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchDestinationHeaderView {
  func configure(with imageDatas: [Data]) {
    dataSource = imageDatas
    collectionView.reloadData()
  }
}

// MARK: - Private Helpers
extension SearchDestinationHeaderView {
  private func setupLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [
      UIColor.black.withAlphaComponent(0.08).cgColor,
      UIColor.clear.cgColor
    ]
    gradientLayer.locations = [0, 0.28]
    layer.addSublayer(gradientLayer)
  }
  
  private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case 0:
        return self?.createImageViewSection()
      default:
        return nil
      }
    }
  }
  
  private func createImageViewSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                           heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    return section
  }
}

// MARK: - UICollectionViewDataSource
extension SearchDestinationHeaderView: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    dataSource.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchDestinationImageCell.identifier,
      for: indexPath
    ) as? SearchDestinationImageCell else { return .init() }
    
    cell.configure(with: dataSource[indexPath.item])
    return cell
  }
}

// MARK: - LayoutSupport
extension SearchDestinationHeaderView: LayoutSupport {
  func addSubviews() {
    addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
