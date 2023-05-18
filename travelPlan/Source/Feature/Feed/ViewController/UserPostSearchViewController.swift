//
//  UserPostSearchViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit
import Combine

final class UserPostSearchViewController: UIViewController {
  // MARK: - Properties
  let viewModel = UserPostSearchViewModel()
  
//  private var dataSource: String?
  
  private lazy var leftAlignedCollectionViewFlowLayout:
  LeftAlignedCollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().set {
    $0.scrollDirection = .vertical
    $0.minimumLineSpacing = 16
    $0.minimumInteritemSpacing = 8
    $0.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
  }
  
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: leftAlignedCollectionViewFlowLayout
  ).set {
    $0.backgroundColor = .systemBackground
    $0.delegate = self
    $0.dataSource = self
    
    $0.register(
      SearchTagCell.self,
      forCellWithReuseIdentifier: SearchTagCell.id
    )
    $0.register(
      UserPostSearchHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: UserPostSearchHeaderView.id
    )
    $0.register(
      RecommendationSearchFooterView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: RecommendationSearchFooterView.id
    )
  }
  
  private var subscriptions = Set<AnyCancellable>()
  private let _viewDidLoad = PassthroughSubject<Void, Never>()
  private let _didTapTagCell = PassthroughSubject<Void, Never>()
  private let _didTapDeleteButton = PassthroughSubject<Void, Never>()
  private let _didTapDeleteAllButton = PassthroughSubject<Void, Never>()
  private let _didTapView = PassthroughSubject<Void, Never>()
  private let _didTapSearchTextField = PassthroughSubject<Void, Never>()
  private let _didTapCancelButton = PassthroughSubject<Void, Never>()
  private let _didTapSearchButton = PassthroughSubject<Void, Never>()
  private let _editingTextField = PassthroughSubject<Void, Never>()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupUI()
    bind()
    setupNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    leftAlignedCollectionViewFlowLayout.headerReferenceSize = CGSize(
      width: self.collectionView.frame.width,
      height: 60
    )
    leftAlignedCollectionViewFlowLayout.footerReferenceSize = CGSize(
      width: self.collectionView.frame.width,
      height: 21
    )
  }
}

// MARK: - Helpers
extension UserPostSearchViewController {
  private func bind() {
    let input = UserPostSearchEvent(
      viewDidLoad: _viewDidLoad.eraseToAnyPublisher(),
      didTapTagCell: _didTapTagCell.eraseToAnyPublisher(),
      didTapDeleteButton: _didTapDeleteButton.eraseToAnyPublisher(),
      didTapDeleteAllButton: _didTapDeleteAllButton.eraseToAnyPublisher(),
      didTapView: _didTapView.eraseToAnyPublisher(),
      didTapSearchTextField: _didTapSearchTextField.eraseToAnyPublisher(),
      didTapCancelButton: _didTapCancelButton.eraseToAnyPublisher(),
      didTapSearchButton: _didTapSearchButton.eraseToAnyPublisher(),
      editingTextField: _editingTextField.eraseToAnyPublisher()
    )
    
    let output = viewModel.transform(input)
    output
      .sink { result in
        switch result {
        case .finished:
          print("completed")
        case let .failure(error):
          print("error: \(error.localizedDescription)")
        }
      } receiveValue: { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  private func render(_ state: UserPostSearchState) {
    switch state {
    case .none: break
    case .gotoBack:
      print("DEBUG: UserPostSearchVC -> FeedVC")
    case .gotoSearch:
      print("DEBUG: UserPostSearchVC -> SearchResultVC")
    case .deleteAllCells: break
      
    case .deleteCell: break
    }
  }
  
  private func fetchHeaderTitle(
    _ headerView: UserPostSearchHeaderView,
    at type: SearchSection
  ) -> String {
    headerView.initSectionType(with: type)
    switch type {
    case .recommendation:
      return viewModel.recommendationModel.headerTitle
    case .recent:
      return viewModel.recentModel.headerTitle
    }
  }
  
  private func setupNavigationBar() {
    // backButtonItem에 image넣어줌.
    // padding: 1. customView 대입, 2. containerView안에 넣어서 inset
    
    //    let backButtonItem = UIBarButtonItem(tit)
  }
}

// MARK: - Actions
extension UserPostSearchViewController {
  @objc private func didTapSearchButton(_ button: UIButton) {
    //    _didTapSearchButton.send(텍스트필드.text)
    print("DEBUG: search button tapped!")
  }
}

// MARK: - LayoutSupport
extension UserPostSearchViewController: LayoutSupport {
  func addSubviews() {
    self.view.addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.top.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserPostSearchViewController: UICollectionViewDelegateFlowLayout {
  // sizeFIXME: - UILabel 사이즈 개선
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return viewModel.sizeForItem(at: indexPath)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let keyword = viewModel.didSelectItem(at: indexPath)
    print(keyword)
  }
}

// MARK: - UICollectionViewDataSource
extension UserPostSearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.numberOfItemsInSection(section)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let searchTagCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchTagCell.id,
      for: indexPath
    ) as? SearchTagCell else { return UICollectionViewCell() }
    
    let tagString = viewModel.cellForItem(searchTagCell, at: indexPath)
    searchTagCell.configure(tagString)
    
    return searchTagCell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    
    switch kind {
    case UICollectionView.elementKindSectionHeader: // HeaderView
      guard let titleHeaderView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: UserPostSearchHeaderView.id,
        for: indexPath
      ) as? UserPostSearchHeaderView else { return UICollectionReusableView() }
      var titleString = ""
      
//      headerView.initSectionType(with: type)
//      switch type {
//      case .recommendation:
//        return viewModel.recommendationModel.headerTitle
//      case .recent:
//        return viewModel.recentModel.headerTitle
//      }
      
      switch indexPath.section {
      case SearchSection.recommendation.rawValue:
        
        // init과 model 접근후 data fetch
        titleString = fetchHeaderTitle(titleHeaderView, at: .recommendation)
      case SearchSection.recent.rawValue:
        titleString = fetchHeaderTitle(titleHeaderView, at: .recent)
      default: break
      }
      // *********************************************
      titleHeaderView.prepare(title: titleString)
      
      return titleHeaderView
      // *********************************************
      
    case UICollectionView.elementKindSectionFooter: // FooterView
      guard let lineFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: RecommendationSearchFooterView.id,
        for: indexPath
      ) as? RecommendationSearchFooterView else { return UICollectionReusableView() }
      
      if indexPath.section == SearchSection.recent.rawValue {
        lineFooterView.isHidden = true
      }
      return lineFooterView
    default: return UICollectionReusableView()
    }
  }
}
