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
  enum Constants {
    enum SearchBarButtonItem {
      static let imageName = "search"
    }
    
    enum SearchTextField {
      static let placeholder = "여행자들의 여행 리뷰를 검색해보세요."
      static let width: CGFloat = 260
      static let fontSize: CGFloat = 16
    }
    
    enum BackButtonItem {
      static let imageName = "back"
    }
    
    enum CollectionViewLayout {
      static let lineSpacing: CGFloat = 16
      static let itemSpacing: CGFloat = 8
      enum Inset {
        static let top: CGFloat = 10
        static let left: CGFloat = 20
        static let bottom: CGFloat = 10
        static let right: CGFloat = 20
      }
    }
    
    enum Alert {
      static let message = "최근 검색 내역을\n모두 삭제하시겠습니까?"
    }
  }
  
  // MARK: - Properties
  private let viewModel = PostSearchViewModel()
  
  weak var coordinator: PostSearchCoordinatorDelegate?
  
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
    $0.font = .init(pretendard: .regular_400(fontSize: Constants.SearchTextField.fontSize))
    $0.autocorrectionType = .no
    $0.delegate = self
  }
  
  private let compositionalLayout: CompositionalLayoutCreatable = DefaultPostSearchLayout()
  private lazy var collectionViewAdapter = PostSearchCollectionViewAdapter(
    dataSource: self.viewModel,
    delegate: self
  )
  private lazy var collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: compositionalLayout.makeLayout()
  ).set {
    $0.delegate = self.collectionViewAdapter
    $0.dataSource = self.collectionViewAdapter
    $0.backgroundColor = .clear
    
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(didTapCollectionView)
    )
    tapGesture.cancelsTouchesInView = false
    $0.addGestureRecognizer(tapGesture)
    
    $0.register(PostRecommendationSearchTagCell.self,
                forCellWithReuseIdentifier: PostRecommendationSearchTagCell.id)
    $0.register(PostRecentSearchTagCell.self,
                forCellWithReuseIdentifier: PostRecentSearchTagCell.id)
    $0.register(PostRecommendationSearchHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PostRecommendationSearchHeaderView.id)
    $0.register(PostRecentSearchHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PostRecentSearchHeaderView.id)
    $0.register(PostSearchFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: PostSearchFooterView.id)
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
    case .reloadSections(let sectionIndex):
      collectionView.reloadSections(.init(integer: sectionIndex))
    case .none: 
      break
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .unexpected:
      print("DEBUG: Unexpected error occured")
    case .deallocated:
      print("DEBUG: Deallocated PostSearchViewModel")
    case .invalidDataSource:
      print("DEBUG: 올바르지 않은 model type입니다.")
    case .none:
      break
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
}

// MARK: - Actions
extension PostSearchViewController {
  @objc private func didTapSearchButton() {
    input.didTapSearchButton.send(self.searchTextField.text ?? "")
  }
  
  @objc private func didTapBackButton() {
    coordinator?.finish(withAnimated: true)
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
  func didTapTagDeleteButton(in recentTagCell: UICollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: recentTagCell) else { return }
    
    input.didTapRecentSearchTagDeleteButton.send(indexPath)
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

// MARK: - PostSearchCollectionViewDelegate
extension PostSearchViewController: PostSearchCollectionViewDelegate {
  func didSelectTag(at indexPath: IndexPath) {
    input.didSelectedItem.send(indexPath)
  }
}
