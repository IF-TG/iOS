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
  private var viewModel: any SearchResultListViewModel
  
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
  
  private var subscriptions = Set<AnyCancellable>()
  
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
    setupUI()
    setupStyles()
    bind()
    input.viewDidLoad.send()
  }
}

// MARK: - Bind
extension SearchResultListViewController {
  func bind() {
    viewModel
      .transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        switch state {
        case .reloadItems(let indexPath):
          let indexPath = [IndexPath(item: indexPath.item, section: indexPath.section)]
          self?.collectionView.reloadItems(at: indexPath)
        case .reloadData:
          self?.collectionView.reloadData()
        case .none:
          break
        }
      }
      .store(in: &subscriptions)
  }
}

// MARK: - UICollectionViewDataSource
extension SearchResultListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.dataSource.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch viewModel.dataSource[section] {
    case .category(let categories):
      return categories.count
    case .destination(let destinationInfos):
      return destinationInfos.count
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch viewModel.dataSource[indexPath.section] {
    case .category(let categories):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchResultCategotyCell.id,
        for: indexPath
      ) as? SearchResultCategotyCell else { return .init() }
      
      cell.configure(with: categories[indexPath.item])
      return cell
    case .destination(let destinationInfos):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TravelDestinationCell.id,
        for: indexPath
      ) as? TravelDestinationCell else { return .init() }
      
      cell.configure(with: destinationInfos[indexPath.item])
      cell.bind(to: input.didTapStarButton, indexPath: indexPath)
      return cell
    }
  }
}

// MARK: - Helpers
extension SearchResultListViewController {
  func setupStyles() {
    view.backgroundColor = .white
  }
}

// MARK: - LayoutSupport
extension SearchResultListViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
