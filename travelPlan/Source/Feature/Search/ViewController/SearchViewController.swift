//
//  SearchViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
  
  // MARK: - Properties
  private let searchView: SearchView = SearchView()
  
  // LayoutFIXME: - CompositionalLayout으로 변경
//  private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().set {
//    $0.headerReferenceSize = CGSize(
//      width: UIScreen.main.bounds.size.width,
//      height: 72
//    )
//  }
  
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).set {
    $0.dataSource = self
    $0.delegate = self
    
    $0.register(
      BestFestivalCell.self,
      forCellWithReuseIdentifier: BestFestivalCell.id
    )
    $0.register(
      SearchHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SearchHeaderView.id
    )
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
  }
}

// MARK: - Helpers
extension SearchViewController {
  private func setupStyles() {
    view.backgroundColor = .white
  }
}

// MARK: - LayoutSupport
extension SearchViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(searchView)
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    searchView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(46)
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(50)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(searchView)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: BestFestivalCell.id,
      for: indexPath
    ) as? BestFestivalCell else { return UICollectionViewCell() }
    
    // modelTODO: - model indexing
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SearchHeaderView.id,
        for: indexPath
      ) as? SearchHeaderView else { return UICollectionReusableView() }
      
      return headerView
    default: return UICollectionReusableView()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.size.width, height: 72)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 140, height: 150)
  }
}
