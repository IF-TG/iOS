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
    $0.register(SearchResultCategoryCell.self, forCellWithReuseIdentifier: SearchResultCategoryCell.id)
    $0.register(TravelDestinationCell.self, forCellWithReuseIdentifier: TravelDestinationCell.id)
    $0.dataSource = self
    $0.delegate = self
    $0.allowsMultipleSelection = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCollectionView))
    tapGesture.cancelsTouchesInView = false
    $0.addGestureRecognizer(tapGesture)
  }
  
  private var selectedTagIndexPath = IndexPath(item: .zero, section: .zero)
  
  private lazy var input = SearchResultListViewModelInput(didChangeSearchTextField: searchTextField.changed)
  
  private var subscriptions = Set<AnyCancellable>()
  
  private lazy var searchBarButtonItem = UIBarButtonItem(
    image: UIImage(named: "search")?
      .withRenderingMode(.alwaysTemplate),
    style: .plain,
    target: self,
    action: #selector(didTapSearchButton)
  ).set {
    $0.tintColor = .yg.primary
  }
  
  private lazy var backButtonItem = UIBarButtonItem(
    image: UIImage(named: "back")?
      .withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: self,
    action: #selector(didTapBackButton)
  )
  
  private lazy var searchTextField: UITextField = UITextField().set {
    $0.attributedPlaceholder = .init(
      string: "여행지 및 축제를 검색해보세요.",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.yg.gray1]
    )
    $0.textColor = .yg.gray5
    $0.font = .init(pretendard: .regular_400(fontSize: 16))
    $0.autocorrectionType = .no
    $0.delegate = self
  }
  
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
    setupNavigationBar()
    bind()
    input.viewDidLoad.send()
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - Bind
extension SearchResultListViewController {
  func bind() {
    viewModel
      .transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self, selectedTagIndexPath] state in
        switch state {
        case .reloadDataWithKeyboardDown:
          self?.searchTextField.endEditing(true)
          self?.collectionView.reloadData()
        case .changeButtonColor(let isChanged):
          if isChanged {
            self?.setupSearchBarButtonItemStyle(.yg.primary, isEnabled: true)
          } else { self?.setupSearchBarButtonItemStyle(.yg.gray1, isEnabled: false) }
        case .reloadItems(let indexPath):
          let indexPath = [IndexPath(item: indexPath.item, section: indexPath.section)]
          self?.collectionView.reloadItems(at: indexPath)
        case .firstReloadData(let searchKeyword):
          self?.searchTextField.text = searchKeyword
          self?.collectionView.reloadData()
          self?.collectionView.selectItem(at: selectedTagIndexPath, animated: false, scrollPosition: [])
        case .reloadSection(let section):
          self?.collectionView.reloadSections(IndexSet(integer: section))
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
        withReuseIdentifier: SearchResultCategoryCell.id,
        for: indexPath
      ) as? SearchResultCategoryCell else { return .init() }
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

// MARK: - UICollectionViewDelegate
extension SearchResultListViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let section = SearchResultSectionIndex(rawValue: indexPath.section) else { return }
    
    switch section {
    case .category:
      collectionView.deselectItem(at: selectedTagIndexPath, animated: false)
      selectedTagIndexPath = indexPath
      guard
        let categoryCell = collectionView.cellForItem(at: indexPath) as? SearchResultCategoryCell
      else { return }
      input.didTapCategoryItem.send((indexPath.item, categoryCell.contentTypeId))
    case .destination:
      if case .destination(let infos) = viewModel.dataSource[indexPath.section] {
        let info = infos[indexPath.item]
        viewModel.showDestinationDetailPage(id: info.id, contentTypeId: info.contentTypeId)
      }
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didDeselectItemAt indexPath: IndexPath
  ) {
    guard let section = SearchResultSectionIndex(rawValue: indexPath.section) else { return }
    
    if case .category = section, selectedTagIndexPath == indexPath {
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
  }
}

// MARK: - Private Helpers
extension SearchResultListViewController {
  private func setupSearchBarButtonItemStyle(_ color: UIColor, isEnabled: Bool) {
    searchBarButtonItem.tintColor = color
    searchBarButtonItem.isEnabled = isEnabled
  }
  
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationBar() {
    let textFieldButtonItem = UIBarButtonItem(customView: searchTextField)
    var barButtonItems = [UIBarButtonItem]()
    
    barButtonItems.append(backButtonItem)
    barButtonItems.append(textFieldButtonItem)
    
    // textField width Layout 지정
    if let customView = textFieldButtonItem.customView {
      customView.snp.makeConstraints {
        $0.width.equalTo(260)
      }
    }
    
    navigationItem.leftBarButtonItems = barButtonItems
    navigationItem.rightBarButtonItem = searchBarButtonItem
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

// MARK: - UITextFieldDelegate
extension SearchResultListViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
  }
}

// MARK: - Actions
private extension SearchResultListViewController {
  @objc func didTapSearchButton() {
    input.didTapSearchButton.send(self.searchTextField.text ?? "")
  }
  
  @objc func didTapBackButton() {
    viewModel.pop()
  }
  
  @objc func didTapCollectionView() {
    searchTextField.endEditing(true)
  }
}
