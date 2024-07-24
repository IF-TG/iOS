//
//  SearchHistoryViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/08.
//

import UIKit
import SnapKit
import Combine

final class SearchHistoryViewController: UIViewController {
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
  private let viewModel: any SearchHistoryViewModel
  
  private lazy var input = SearchHistoryViewModelInput(didChangeSearchTextField: searchTextField.changed)
  
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
  
  private let compositionalLayout: CompositionalLayoutCreatable = DefaultSearchHistoryLayout()
  private lazy var collectionViewAdapter = SearchHistoryCollectionViewAdapter(
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
    $0.register(type: SearchHistoryRecommendationTagCell.self)
    $0.register(type: SearchHistoryRecentTagCell.self)
    $0.register(type: PostRecommendationSearchHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(type: PostRecentSearchHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    $0.register(type: SearchHistoryFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(viewModel: any SearchHistoryViewModel) {
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
    setupNavigationBar()
    input.viewDidLoad.send()
  }
  
  deinit {
    print("deinit: \(SearchHistoryViewController.self)")
  }
}

// MARK: - Bind
extension SearchHistoryViewController {
  private func bind() {
    let output = self.viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        
        switch state {
        case .resignFirstResponder:
          searchTextField.resignFirstResponder()
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
        case .reloadData:
          collectionView.reloadData()
        case .none:
          break
        case .unexpectedError(description: let description):
          print("viewController 에러 발생 처리: \(description)")
        }
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Helpers
extension SearchHistoryViewController {
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
extension SearchHistoryViewController {
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
extension SearchHistoryViewController: LayoutSupport {
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
extension SearchHistoryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    input.didTapSearchButton.send(textField.text ?? "")
    return true
  }
}

// MARK: - SearchHistoryHeaderViewDelegate
extension SearchHistoryViewController: SearchHistoryHeaderViewDelegate {
  func didTapDeleteAllButton() {
    input.didTapDeleteAllButton.send()
  }
}

// MARK: - SearchHistoryRecentTagCellDelegate
extension SearchHistoryViewController: SearchHistoryRecentTagCellDelegate {
  func didTapTagDeleteButton(in recentTagCell: UICollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: recentTagCell) else { return }
    
    input.didTapRecentSearchTagDeleteButton.send(indexPath)
  }
}

// MARK: - CautionAlertViewControllerDelegate
extension SearchHistoryViewController: CautionAlertViewControllerDelegate {
  func didTapAlertConfirm() {
    input.didTapDeleteAllAlert.send()
  }
  
  func didTapAlertCancel() {
    input.didTapAlertCancelButton.send()
  }
}

// MARK: - SearchHistoryCollectionViewDelegate
extension SearchHistoryViewController: SearchHistoryCollectionViewDelegate {
  func didSelectTag(at indexPath: IndexPath) {
    input.didSelectedItem.send(indexPath)
  }
}
