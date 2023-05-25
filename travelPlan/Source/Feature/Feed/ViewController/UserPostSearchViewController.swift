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
  private let viewModel = UserPostSearchViewModel()
  
  lazy var input = Input(didTapSearchTextField: searchTextField.changed)
  
  private lazy var searchBarButtonItem = UIBarButtonItem(
    image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate),
    style: .plain,
    target: self,
    action: #selector(didTapSearchButton)
  ).set {
    $0.isEnabled = true
    $0.tintColor = .yg.gray1
  }
  
  private lazy var backButtonItem = UIBarButtonItem(
    image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: self,
    action: #selector(didTapBackButton)
  )
  
  private lazy var searchTextField: UITextField = UITextField().set {
    $0.placeholder = "여행자들의 여행 리뷰를 검색해보세요."
    $0.textColor = .yg.gray5
    $0.font = .init(pretendard: .regular, size: 16)
    $0.autocorrectionType = .no
    $0.delegate = self
  }
  
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
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(didTapCollectionView)
    )
    tapGesture.cancelsTouchesInView = false
    $0.addGestureRecognizer(tapGesture)
    
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
  
  // Combine
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
    bind()
    setupNavigationBar()
  }
}

// MARK: - ViewBindCase
extension UserPostSearchViewController: ViewBindCase {
  typealias Input = UserPostSearchViewModel.Input
  typealias ErrorType = UserPostSearchViewModel.ErrorType
  typealias State = UserPostSearchViewModel.State
  
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
      print("DEBUG: UserPostSearchVC -> SearchResultVC, keyword:\(text)")
    case .presentAlert:
      showAlert(alertType: .withCancel, message: "최근 검색 내역을\n모두 삭제하시겠습니까?", target: self)
    case .deleteCell(let section):
      collectionView.reloadSections(IndexSet(section...section))
    case .deleteAllCells(let section):
      collectionView.reloadSections(IndexSet(section...section))
    case .changeButtonColor(let isChanged):
      if isChanged {
        setupSearchBarButtonItemStyle(.yg.primary, isEnabled: true)
      } else { setupSearchBarButtonItemStyle(.yg.gray1, isEnabled: false) }
    case.goDownKeyboard:
      navigationController?.navigationBar.endEditing(true)
    case .none: break
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .none:
      print("DEBUG: Error not occured")
    case .unexpected:
      print("DEBUG: Unexpected error occured")
    }
  }
}

// MARK: - Helpers
extension UserPostSearchViewController {
  private func setupSearchBarButtonItemStyle(_ color: UIColor, isEnabled: Bool) {
    searchBarButtonItem.tintColor = color
    searchBarButtonItem.isEnabled = isEnabled
  }
  
  private func setupNavigationBar() {
    let textFieldButtonItem = UIBarButtonItem(customView: searchTextField)
    var barButtonItems = [UIBarButtonItem]()
    
    barButtonItems.append(backButtonItem)
    barButtonItems.append(textFieldButtonItem)
    
    // textField width autoLayout 지정
    if let customView = textFieldButtonItem.customView {
      customView.snp.makeConstraints {
        $0.width.equalTo(260)
      }
    }
    
    navigationItem.leftBarButtonItems = barButtonItems
    navigationItem.rightBarButtonItem = searchBarButtonItem
  }
}

// MARK: - Actions
extension UserPostSearchViewController {
  @objc private func didTapSearchButton() {
    input.didTapSearchButton.send(self.searchTextField.text ?? "")
  }
  
  @objc private func didTapBackButton() {
    input.didTapBackButton.send()
  }
  
  @objc private func editingChangedTextField(_ textField: UITextField) {
    input.editingTextField.send(textField.text ?? "")
  }
  
  @objc private func didTapCollectionView() {
    input.didTapCollectionView.send()
  }
}

// MARK: - LayoutSupport
extension UserPostSearchViewController: LayoutSupport {
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
    input.didSelectedItem.send(indexPath)
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
    searchTagCell.delegate = self
    
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
      // HeaderView
    case UICollectionView.elementKindSectionHeader:
      guard let titleHeaderView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: UserPostSearchHeaderView.id,
        for: indexPath
      ) as? UserPostSearchHeaderView else { return UICollectionReusableView() }
      
      titleHeaderView.delegate = self
      let titleString = viewModel.fetchHeaderTitle(titleHeaderView, at: indexPath.section)
      titleHeaderView.prepare(title: titleString)
      
      return titleHeaderView
      
      // FooterView
    case UICollectionView.elementKindSectionFooter:
      guard let lineFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: RecommendationSearchFooterView.id,
        for: indexPath
      ) as? RecommendationSearchFooterView else { return UICollectionReusableView() }
     
      if viewModel.isRecentSection(at: indexPath.section) {
        lineFooterView.isHidden = true
      }

      return lineFooterView
    default: return UICollectionReusableView()
    }
  }
}

// MARK: - UITextFieldDelegate
extension UserPostSearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    input.didTapSearchButton.send(textField.text ?? "")
    return true
  }
}

// MARK: - UserPostSearchHeaderViewDelegate
extension UserPostSearchViewController: UserPostSearchHeaderViewDelegate {
  func didTapDeleteAllButton() {
    input.didTapDeleteAllButton.send()
  }
}

// MARK: - SearchTagCellDelegate
extension UserPostSearchViewController: SearchTagCellDelegate {
    func didTapDeleteButton(item: Int, in section: Int) {
      input.didTapDeleteButton.send((item, section))
    }
}

// MARK: - CautionAlertViewControllerDelegate
extension UserPostSearchViewController: CautionAlertViewControllerDelegate {
  func didTapAlertConfirm() {
    input.didTapAlertConfirmButton.send()
    print("confirm Alert")
  }
  
  func didTapAlertCancel() {
    print("cancel Alert")
  }
}

// CellLayoutFIXME: - 최근 검색 키워드 충분히 길어진 경우, 잘못된 tag cell size
