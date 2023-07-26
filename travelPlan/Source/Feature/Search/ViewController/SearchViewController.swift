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
  weak var coordinator: SearchCoordinator?
  private let viewModel = SearchViewModel()
  private lazy var searchView: SearchView = .init().set {
    $0.delegate = self
  }
  
  private var isScrolledUntilTop = false
  
  private var subscriptions = Set<AnyCancellable>()
  private lazy var input = SearchViewModel.Input()
  private let compositionalLayout: SearchCollectionViewCompositionalLayout = SearchCollectionViewCompositionalLayout()
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
    input.viewDidLoad.send()
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
    case .setButtonColor:
      collectionView.reloadData()
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
    switch viewModel.getCellViewModels(in: indexPath.section) {
      
    case .festival(let viewModels, _):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchBestFestivalCell.id,
        for: indexPath
      ) as? SearchBestFestivalCell else { return .init() }
      cell.configure(viewModel: viewModels[indexPath.item])
      return cell
      
    case .famous(let viewModels, _):
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchFamousSpotCell.id, for: indexPath
      ) as? SearchFamousSpotCell else { return .init() }
      
      cell.configure(viewModel: viewModels[indexPath.item])
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
    
      let headerModel = viewModel.fetchHeaderTitle(in: indexPath.section)
      headerView.configure(header: headerModel)
      
      return headerView
    } else { return .init() }
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
    // pushTODO: - detailVC 화면 전환
    print("[\(indexPath.section), \(indexPath.item)] clicked")
  }
}

// MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {
  func didTapSearchButton(text: String) {
    input.didTapSearchButton.send(text)
  }
}
