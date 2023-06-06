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
  private let viewModel = SearchViewModel()
  private let searchView: SearchView = SearchView()
  
  // LayoutFIXME: - CompositionalLayout으로 변경
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createLayout()
  ).set {
    $0.dataSource = self
    $0.delegate = self
    
    $0.register(
      SearchBestFestivalCell.self,
      forCellWithReuseIdentifier: SearchBestFestivalCell.id
    )
    $0.register(
      SearchFamousSpotCell.self,
      forCellWithReuseIdentifier: SearchFamousSpotCell.id
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
}

// MARK: - Helpers
extension SearchViewController {
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] section, _ in
      guard let self = self else { return nil }
      switch self.viewModel.models[section] {
      case .bestFestival:
        // item
        let item = NSCollectionLayoutItem(layoutSize: .init(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)
        ))
        
        // group
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .absolute(140),
            heightDimension: .absolute(150)
          ),
          subitems: [item]
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()] // 헤더의 layout 처리
        
        // availableTODO: - 16버전은 사용 불가능, 버전에 따라 처리 해주어야 합니다.
        section.supplementariesFollowContentInsets = false // false의 경우, item의 contentInset을 무시하고 size 설정
        return section
      case .famousSpot:
        // item
        let item = NSCollectionLayoutItem(layoutSize: .init(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(0.3)
        ))
        
        // group
        let group = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.87),
            heightDimension: .absolute(360)
          ),
          subitems: [item]
        )
        group.interItemSpacing = .fixed(10)
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: UIScreen.main.bounds.size.width*0.13)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()] // 헤더의 layout 처리
        section.supplementariesFollowContentInsets = false
        
        return section
      }
    }
  }
  
  private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    return .init(
      layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(74)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
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
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(50)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(searchView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.models.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch viewModel.models[section] {
    case let .bestFestival(festivalItems):
      return festivalItems.count
    case let .famousSpot(spotItems):
      return spotItems.count
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch viewModel.models[indexPath.section] {
    case let .bestFestival(festivalItems):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchBestFestivalCell.id,
        for: indexPath
      ) as? SearchBestFestivalCell else { return UICollectionViewCell() }
      
      cell.configure(festivalItems[indexPath.item])
      return cell
    case let .famousSpot(spotItems):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchFamousSpotCell.id, for: indexPath
      ) as? SearchFamousSpotCell else { return UICollectionViewCell() }
      
      cell.configure(spotItems[indexPath.item])
      return cell
    }
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
      
      let title = viewModel.models[indexPath.section].headerTitle
      headerView.configure(title)
      
      return headerView
    default: return UICollectionReusableView()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print(scrollView.contentOffset.y)
    
    if 40 - scrollView.contentOffset.y * 3 > 0 {
      searchView.snp.updateConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide).inset(40 - scrollView.contentOffset.y * 3)
        $0.leading.trailing.equalToSuperview().inset(30)
        $0.height.equalTo(50)
      }
    } else if 40 - scrollView.contentOffset.y * 3 <= 0 {
      searchView.snp.updateConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide)
        $0.leading.trailing.equalToSuperview().inset(30)
        $0.height.equalTo(50)
      }
    }
  }
}
