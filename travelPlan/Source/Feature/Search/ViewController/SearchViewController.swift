//
//  SearchViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import Combine
import UIKit

import SnapKit

final class SearchViewController: UIViewController {
  
  // MARK: - Properties
  private let viewModel = SearchViewModel()
  private lazy var searchView: SearchView = .init().set {
    $0.delegate = self
  }
  
  private var isScrolledUntilTop = false
  
  private var subscriptions = Set<AnyCancellable>()
  private lazy var input = SearchViewModel.Input()
  
  // LayoutFIXME: - CompositionalLayout으로 변경
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createLayout()
  ).set {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(didTapCollectionView)
    )
    tapGesture.cancelsTouchesInView = false
    $0.addGestureRecognizer(tapGesture)
    
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
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
}

// MARK: - Bind
extension SearchViewController {
  private func bind() {
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] result in
        switch result {
        case .finished:
          print("completed")
        case let .failure(error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  private func handleError(_ error: SearchViewModel.ErrorType) {
    switch error {
    case .none: print("DEBUG: none error")
    case .unexpected: print("DEBUG: unexpected error")
    }
  }
  
  private func render(_ state: SearchViewModel.State) {
    switch state {
    case .goDownKeyboard:
      searchView.endEditing(true)
      
    case .gotoSearch:
      print("해당 text를 기반으로 vc 전환")
    }
  }
}

// MARK: - Actions
extension SearchViewController {
  @objc private func didTapCollectionView() {
    input.didTapView.send()
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
      
      switch self.viewModel.fetchModel(in: section) {
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
    return viewModel.numberOfSections()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.numberOfItemsInSection(in: section)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch viewModel.fetchModel(in: indexPath.section) {
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
      
      let title = viewModel.fetchHeaderTitle(in: indexPath.section)
      headerView.configure(title)
      
      return headerView
    default: return UICollectionReusableView()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentTopMargin = 40 - scrollView.contentOffset.y
    isScrolledUntilTop = currentTopMargin > 0

    if isScrolledUntilTop {
      searchView.snp.updateConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide).inset(currentTopMargin)
      }
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    print("[\(indexPath.section), \(indexPath.item)] clicked")
  }
}

extension SearchViewController: SearchViewDelegate {
  func didTapSearchButton(text: String) {
    input.didTapSearchButton.send(text)
  }
}
