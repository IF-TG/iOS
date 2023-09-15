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
  enum Constants {
    enum SearchView {
      enum Spacing {
        static let top: CGFloat = 20
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
      }
      static let height: CGFloat = 50
    }
    
    enum CollectionView {
      enum Spacing {
        enum Offset {
          static let top: CGFloat = 20
        }
      }
    }
  }
  
  // MARK: - Properties
  weak var coordinator: SearchCoordinator?
  private let viewModel = SearchViewModel()
  private lazy var searchView: SearchView = .init().set {
    $0.delegate = self
  }
  
  private var isScrolledUntilTop = false
  
  private var subscriptions = Set<AnyCancellable>()
  private lazy var input = SearchViewModel.Input()
  private let compositionalLayout: SearchLayout = DefaultSearchLayout()
  
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: compositionalLayout.createLayout()
  ).set {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(didTapCollectionView)
    )
    tapGesture.cancelsTouchesInView = false
    $0.addGestureRecognizer(tapGesture)
    
    $0.dataSource = self
    $0.delegate = self
    $0.backgroundColor = .clear
    $0.register(SearchBestFestivalCell.self,
                forCellWithReuseIdentifier: SearchBestFestivalCell.id)
    $0.register(TravelDestinationCell.self,
                forCellWithReuseIdentifier: TravelDestinationCell.id)
    $0.register(SearchHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchHeaderView.id)
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    bind()
    input.viewDidLoad.send()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchView.setupShadowLayer()
  }
}

// MARK: - ViewBindCase
extension SearchViewController: ViewBindCase {
  typealias Input = SearchViewModel.Input
  typealias ErrorType = SearchViewModel.ErrorType
  typealias State = SearchViewModel.State
  
  internal func bind() {
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] result in
        switch result {
        case .finished:
          print("DEBUG: completed")
        case let .failure(error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  internal func handleError(_ error: ErrorType) {
    switch error {
    case .none: print("DEBUG: none error")
    case .unexpected: print("DEBUG: unexpected error")
    }
  }
  
  internal func render(_ state: State) {
    switch state {
    case .goDownKeyboard:
      searchView.endEditing(true)
    case .gotoSearch:
      print("해당 text를 기반으로 vc 전환")
    case .none: break
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
  
  private func headerType(for section: Int) -> SearchSectionType? {
    switch section {
    case SearchSectionType.festival.rawValue:
      return .festival
    case SearchSectionType.famous.rawValue:
      return .famous
    default: return nil
    }
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
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.SearchView.Spacing.top)
      $0.leading.equalToSuperview()
        .inset(Constants.SearchView.Spacing.leading)
      $0.trailing.equalToSuperview()
        .inset(Constants.SearchView.Spacing.trailing)
      $0.height.equalTo(Constants.SearchView.height)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(searchView.snp.bottom).offset(Constants.CollectionView.Spacing.Offset.top)
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
    switch viewModel.getCellViewModels(in: indexPath.section) {
      
    case let .festival(festivalViewModels):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchBestFestivalCell.id,
        for: indexPath
      ) as? SearchBestFestivalCell else { return .init() }
      
      cell.configure(with: festivalViewModels[indexPath.item])
      return cell
      
    case let .famous(famousViewModels):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TravelDestinationCell.id,
        for: indexPath
      ) as? TravelDestinationCell else { return .init() }
      
      cell.configure(with: famousViewModels[indexPath.item])
      return cell
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if case UICollectionView.elementKindSectionHeader = kind {
      guard let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SearchHeaderView.id,
        for: indexPath
      ) as? SearchHeaderView else { return .init() }
      
      headerView.delegate = self
      headerView.type = headerType(for: indexPath.section)
      
      let headerTitle = viewModel.fetchHeaderTitle(in: indexPath.section)
      headerView.configure(title: headerTitle)
      
      return headerView
    } else { return .init() }
  }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentTopMargin = Constants.SearchView.Spacing.top - scrollView.contentOffset.y
    isScrolledUntilTop = currentTopMargin > CGFloat.zero

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
    // pushTODO: - detailVC 화면 전환
    print("[\(indexPath.section), \(indexPath.item)] clicked")
  }
}

// MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {
  func didTapSearchButton(_ searchView: SearchView, text: String) {
    input.didTapSearchButton.send(text)
  }
}

// MARK: - SearchHeaderViewDelegate
extension SearchViewController: SearchHeaderViewDelegate {
  // pushTODO: - 각 타입에 맞게 화면전환을 해야합니다.
  func didTaplookingMoreButton(_ headerView: SearchHeaderView) {
    switch headerView.type {
    case .festival:
      print("DEBUG: 베스트 축제 더보기 클릭")
    case .famous:
      print("DEBUG: 유명 관광지 더보기 클릭")
    case .none: break
    }
  }
}
