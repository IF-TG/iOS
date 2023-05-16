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
  
  private var dataSource: String?
  
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
//    BaseNavigationController.configureBackButtonItem(title: "헬로", target: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    leftAlignedCollectionViewFlowLayout.headerReferenceSize = CGSize(
      width: self.collectionView.frame.width,
      height: 60
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
    let widthPadding: CGFloat = 13
    let heightPadding: CGFloat = 4
    
    if indexPath.section == SearchSection.recommendation.rawValue {
      let text = viewModel.recommendationModel.keywords[indexPath.item]
      let textSize = (text as NSString)
        .size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
      
      return CGSize(
        width: textSize.width + (widthPadding * 2),
        height: textSize.height + (heightPadding * 2)
      )
    } else if indexPath.section == SearchSection.recent.rawValue {
      let text = viewModel.recentModel.keywords[indexPath.item]
      let textSize = (text as NSString)
        .size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
      
      // widthSizeFIXME: - 버튼의 width 계산하기
      // AutoLayout을 사용할 수 없어서 문제를 해결하지 못하여, 임시 방편으로 buttonWidth 상수를 사용했습니다.
      let buttonWidth: CGFloat = 10
      let componentPadding: CGFloat = 4
      
      let width = textSize.width + componentPadding + buttonWidth + (widthPadding * 2)
      
      return CGSize(
        width: width,
        height: textSize.height + (heightPadding * 2)
      )
    } else { return CGSize() }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let searchTagCell = collectionView.cellForItem(at: indexPath) as? SearchTagCell else { return }
    
    switch searchTagCell.sectionType {
    case .recommendation:
      print("추천 검색어: \(viewModel.recommendationModel.keywords[indexPath.item]) tapped")
//      self.navigationController?.pushViewController(DummyViewController(), animated: true)
    case .recent:
      print("최근 검색어: \(viewModel.recentModel.keywords[indexPath.item]) tapped")
    case .none: return
    }
  }
}

// MARK: - UICollectionViewDataSource
extension UserPostSearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SearchSection.allCases.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    switch section {
    case SearchSection.recommendation.rawValue:
      return viewModel.recommendationModel.keywords.count
    case SearchSection.recent.rawValue:
      return viewModel.recentModel.keywords.count
    default: return 0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
//    viewModel.collectionView(collectionView, cellForItemAt: indexPath)
    guard let searchTagCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchTagCell.id,
      for: indexPath
    ) as? SearchTagCell else { return UICollectionViewCell() }
    
    // 하나의 Cell class를 재사용해서 변형시키므로, section별로 Cell 구분화
    switch indexPath.section {
    case SearchSection.recommendation.rawValue:
      searchTagCell.initSectionType(with: .recommendation)
      self.dataSource = viewModel.recommendationModel.keywords[indexPath.item]
    case SearchSection.recent.rawValue:
      searchTagCell.initSectionType(with: .recent)
      self.dataSource = viewModel.recentModel.keywords[indexPath.item]
    default: break
    }
    guard let dataSource = self.dataSource else { return searchTagCell }
    searchTagCell.configure(dataSource)
    
    return searchTagCell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      
      guard let titleHeaderView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: UserPostSearchHeaderView.id,
        for: indexPath
      ) as? UserPostSearchHeaderView else { return UICollectionReusableView() }
      
//      viewModel.fetchHeaderTitle(titleHeaderView, at: .recommendation)
      // viewModel에게 CollectionReusableView와 cell Type을 넘긴다.
      
      var titleString = ""
      
      switch indexPath.section {
      case SearchSection.recommendation.rawValue:
        titleString = fetchHeaderTitle(titleHeaderView, at: .recommendation)
      case SearchSection.recent.rawValue:
        titleString = fetchHeaderTitle(titleHeaderView, at: .recent)
      default: break
      }
      
      titleHeaderView.prepare(title: titleString)
      
      return titleHeaderView
    default: return UICollectionReusableView()
    }
  }
}
