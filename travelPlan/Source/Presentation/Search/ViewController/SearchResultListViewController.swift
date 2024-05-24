//
//  SearchResultListViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 5/20/24.
//

import UIKit
import Combine

final class SearchResultListViewController: UIViewController {
  // MARK: - Dependencies
  private let viewModel: any SearchResultListViewModel
  
  // MARK: - Properties
  private lazy var compositionalLayout = {
    return UICollectionViewCompositionalLayout { sectionIndex, _ in
      switch sectionIndex {
      case 0:
        return CollectionLayoutSectionProvider.createOneLineTagSection()
      case 1:
        let group = TravelDestinationLayoutGroupProvider.createDefaultGroup()
        return NSCollectionLayoutSection(group: group)
      default:
        return nil
      }
    }
  }()
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: compositionalLayout
  ).set {
    $0.register(SearchResultCategotyCell.self, forCellWithReuseIdentifier: SearchResultCategotyCell.id)
    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
    $0.dataSource = self
  }
  private let input = SearchResultListViewModelInput()
  
  // MARK: - LifeCycle
  init(viewModel: any SearchResultListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

// MARK: - UICollectionViewDataSource
extension SearchResultListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    1
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TravelDestinationCell.id,
      for: indexPath
    ) as? TravelDestinationCell else { return .init() }
    
    cell.configure(with: TravelDestinationInfo(place: "캠핑 타이틀",
                                  category: "캠핑",
                                  location: "강원",
                                  isButtonSelected: false,
                                  imageData: Data(),
                                  id: 12345))
    cell.bind(to: input.didTapStarButton, indexPath: indexPath)
    
    return cell
  }
}
