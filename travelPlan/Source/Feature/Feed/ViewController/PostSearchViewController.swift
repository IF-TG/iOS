//
//  PostSearchViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit
import Combine

final class PostSearchViewController: UIViewController {
  // MARK: - Properties
  private let viewModel = PostSearchViewModel()
  
  weak var coordinator: PostSearchCoordinator?
  
  private lazy var input = Input(didChangeSearchTextField: searchTextField.changed)
  
  private lazy var searchBarButtonItem = UIBarButtonItem(
    image: UIImage(named: Constants.SearchBarButtonItem.imageName)?
      .withRenderingMode(.alwaysTemplate),
    style: .plain,
    target: self,
    action: #selector(didTapSearchButton)
  ).set {
    $0.isEnabled = false
    $0.tintColor = .yg.gray1
  }
  
  private lazy var backButtonItem = UIBarButtonItem(
    image: UIImage(named: Constants.BackButtonItem.imageName)?
      .withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: self,
    action: #selector(didTapBackButton)
  )
  
  private lazy var searchTextField: UITextField = UITextField().set {
    $0.attributedPlaceholder = .init(
      string: Constants.SearchTextField.placeholder,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.yg.gray1]
    )
    $0.textColor = .yg.gray5
    $0.font = .init(pretendard: .regular, size: Constants.SearchTextField.fontSize)
    $0.autocorrectionType = .no
    $0.delegate = self
  }
  
  private let compositionalLayout: PostSearchLayout = DefaultPostSearchLayout()
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
    
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dataSource = self
    
    $0.register(
      PostRecommendationSearchTagCell.self,
      forCellWithReuseIdentifier: PostRecommendationSearchTagCell.id
    )
    $0.register(
      PostRecentSearchTagCell.self,
      forCellWithReuseIdentifier: PostRecentSearchTagCell.id
    )
    $0.register(
      PostRecommendationSearchHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecommendationSearchHeaderView.id
    )
    $0.register(
      PostRecentSearchHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecentSearchHeaderView.id
    )
    $0.register(
      PostSearchFooterView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: PostSearchFooterView.id
    )
  }
  
  // Combine
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    bind()
    setupNavigationBar()
    input.viewDidLoad.send()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    coordinator?.finish()
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - ViewBindCase
extension PostSearchViewController: ViewBindCase {
  typealias Input = PostSearchViewModel.Input
  typealias ErrorType = PostSearchViewModel.ErrorType
  typealias State = PostSearchViewModel.State
  
  func bind() {
    let output = self.viewModel.transform(input)
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
  
  func render(_ state: State) {
    switch state {
    case .gotoBack:
      navigationController?.popViewController(animated: true)
    case .gotoSearch(let text):
      searchTextField.resignFirstResponder()
      print("DEBUG: PostSearchVC -> PostSearchResultVC, keyword:\(text)")
    case .presentAlert:
      showAlert(alertType: .withCancel, message: Constants.Alert.message, target: self)
    case .changeButtonColor(let isChanged):
      if isChanged {
        setupSearchBarButtonItemStyle(.yg.primary, isEnabled: true)
      } else { setupSearchBarButtonItemStyle(.yg.gray1, isEnabled: false) }
    case.goDownKeyboard:
      navigationController?.navigationBar.endEditing(true)
    case .showRecommendationCollection:
      print("DEBUG: text에 따른 collectionView 변화")
    case .runtoCancelLogic:
      print("DEBUG: cancel버튼 클릭했을 때의 logic 실행")
    case .reloadData:
      collectionView.reloadData()
    case .none: break
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .none: break
    case .unexpected:
      print("DEBUG: Unexpected error occured")
    case .deallocated:
      print("DEBUG: Deallocated PostSearchViewModel")
    case .invalidDataSource:
      print("DEBUG: 올바르지 않은 model type입니다.")
    }
  }
}

// MARK: - Helpers
extension PostSearchViewController {
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func setupSearchBarButtonItemStyle(_ color: UIColor, isEnabled: Bool) {
    searchBarButtonItem.tintColor = color
    searchBarButtonItem.isEnabled = isEnabled
  }
  
  private func setupNavigationBar() {
    let textFieldButtonItem = UIBarButtonItem(customView: searchTextField)
    var barButtonItems = [UIBarButtonItem]()
    
    barButtonItems.append(backButtonItem)
    barButtonItems.append(textFieldButtonItem)
    
    // textField width Layout 지정
    if let customView = textFieldButtonItem.customView {
      customView.snp.makeConstraints {
        $0.width.equalTo(Constants.SearchTextField.width)
      }
    }
    
    navigationItem.leftBarButtonItems = barButtonItems
    navigationItem.rightBarButtonItem = searchBarButtonItem
  }
  
  private func headerView(
    for indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    switch viewModel.fetchHeaderTitle(in: indexPath.section) {
    case let .recommendation(title):
      return self.recommendationHeaderView(for: indexPath, title: title, in: collectionView)
    case let .recent(title):
      return self.recentHeaderView(for: indexPath, title: title, in: collectionView)
    }
  }
  
  private func recommendationHeaderView(
    for indexPath: IndexPath,
    title: String,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let recommendationHeaderView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecommendationSearchHeaderView.id,
      for: indexPath
    ) as? PostRecommendationSearchHeaderView else { return .init() }
    
    recommendationHeaderView.prepare(title: title)
    return recommendationHeaderView
  }
  
  private func recentHeaderView(
    for indexPath: IndexPath,
    title: String,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let recentHeaderView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecentSearchHeaderView.id,
      for: indexPath
    ) as? PostRecentSearchHeaderView else { return .init() }
    
    recentHeaderView.delegate = self
    recentHeaderView.prepare(title: title)
    
    return recentHeaderView
  }
  
  private func footerView(
    for indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    // 추천 검색
    if indexPath.section == Constants.SearchSection.recommendation {
      guard let lineFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionFooter,
        withReuseIdentifier: PostSearchFooterView.id,
        for: indexPath
      ) as? PostSearchFooterView else { return .init() }
      return lineFooterView
    } else {
      return UICollectionReusableView()
    }
  }
}

// MARK: - Actions
extension PostSearchViewController {
  @objc private func didTapSearchButton() {
    input.didTapSearchButton.send(self.searchTextField.text ?? "")
  }
  
  @objc private func didTapBackButton() {
    input.didTapBackButton.send()
  }
  
  @objc private func didTapCollectionView() {
    input.didTapCollectionView.send()
  }
}

// MARK: - LayoutSupport
extension PostSearchViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    self.collectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.top.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PostSearchViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    input.didSelectedItem.send(indexPath)
  }
}

// MARK: - UICollectionViewDataSource
extension PostSearchViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.numberOfItems(in: section)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch viewModel.cellForItems(at: indexPath.section) {
    case let .recommendation(items):
      guard let recommendationSearchTagCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PostRecommendationSearchTagCell.id,
        for: indexPath
      ) as? PostRecommendationSearchTagCell else { return .init() }
      
      recommendationSearchTagCell.configure(items[indexPath.item])
      return recommendationSearchTagCell
    case let .recent(items):
      guard let recentSearchTagCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PostRecentSearchTagCell.id,
        for: indexPath
      ) as? PostRecentSearchTagCell else { return .init() }
      
      recentSearchTagCell.delegate = self
      recentSearchTagCell.configure(items[indexPath.item])
      return recentSearchTagCell
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      return headerView(for: indexPath, in: collectionView)
    case UICollectionView.elementKindSectionFooter:
      return footerView(for: indexPath, in: collectionView)
    default:
      return UICollectionReusableView()
    }
  }
}

// MARK: - UITextFieldDelegate
extension PostSearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    input.didTapSearchButton.send(textField.text ?? "")
    return true
  }
}

// MARK: - PostSearchHeaderViewDelegate
extension PostSearchViewController: PostSearchHeaderViewDelegate {
  func didTapDeleteAllButton() {
    input.didTapDeleteAllButton.send()
  }
}

// MARK: - PostRecentSearchTagCellDelegate
extension PostSearchViewController: PostRecentSearchTagCellDelegate {
  func didTapTagDeleteButton(in recentTagCell: PostRecentSearchTagCell) {
    // questionTODO: -  다운캐스팅을 해야 하는가? 추후 실험해보고 필요없다면, UICollectionViewCell로 업캐스팅 해둘 것
    guard let indexPath = collectionView.indexPath(for: recentTagCell) else { return }
    input.didTapRecentSearchTagDeleteButton.send(indexPath.item)
  }
}

// MARK: - CautionAlertViewControllerDelegate
extension PostSearchViewController: CautionAlertViewControllerDelegate {
  func didTapAlertConfirm() {
    input.didTapDeleteAllAlert.send()
  }
  
  func didTapAlertCancel() {
    input.didTapAlertCancelButton.send()
  }
}
