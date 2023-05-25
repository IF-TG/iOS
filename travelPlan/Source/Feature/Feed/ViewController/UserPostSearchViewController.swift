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
    $0.addTarget(self, action: #selector(editingChangedTextField), for: .editingChanged)
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
  private let _didSelectedItem = PassthroughSubject<IndexPath, Never>()
  private let _didTapDeleteButton = PassthroughSubject<(Int, Int), Never>()
  private let _didTapDeleteAllButton = PassthroughSubject<Void, Never>()
  private let _didTapCollectionView = PassthroughSubject<Void, Never>()
  private let _didTapSearchButton = PassthroughSubject<String, Never>()
  private let _editingTextField = PassthroughSubject<String, Never>()
  private let _didTapEnterAlertAction = PassthroughSubject<Void, Never>()
  private let _didTapBackButton = PassthroughSubject<Void, Never>()
  
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
  typealias ViewModelError = UserPostSearchViewModel.Error
  typealias State = UserPostSearchViewModel.State
  
  func bind() {
    let input = Input(
      didSelectedItem: _didSelectedItem.eraseToAnyPublisher(),
      didTapDeleteButton: _didTapDeleteButton.eraseToAnyPublisher(),
      didTapDeleteAllButton: _didTapDeleteAllButton.eraseToAnyPublisher(),
      didTapCollectionView: _didTapCollectionView.eraseToAnyPublisher(),
      didTapSearchButton: _didTapSearchButton.eraseToAnyPublisher(),
      editingTextField: _editingTextField.eraseToAnyPublisher(),
      didTapEnterAlertAction: _didTapEnterAlertAction.eraseToAnyPublisher(),
      didTapBackButton: _didTapBackButton.eraseToAnyPublisher()
    )
    
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
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
  
  func render(_ state: State) {
    switch state {
    case .gotoBack:
      navigationController?.popViewController(animated: true)
    case .gotoSearch(let text):
      searchTextField.resignFirstResponder()
      print("DEBUG: UserPostSearchVC -> SearchResultVC, keyword:\(text)")
    case .presentAlert:
      setupAlertController()
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
}

// MARK: - Helpers
extension UserPostSearchViewController {
  private func setupSearchBarButtonItemStyle(_ color: UIColor, isEnabled: Bool) {
    searchBarButtonItem.tintColor = color
    searchBarButtonItem.isEnabled = isEnabled
  }
  
  private func setupAlertController() {
    let message = "최근 검색 내역을\n모두 삭제하시겠습니까?"
    let attrMessageString = NSMutableAttributedString(string: message)
//    let style = NSMutableParagraphStyle()
//    style.lineSpacing = 5
    attrMessageString.addAttributes(
      [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.black
//        .paragraphStyle: style
      ],
      range: NSRange(location: 0, length: attrMessageString.length)
    )
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    alert.setValue(attrMessageString, forKey: "attributedTitle")
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
      self._didTapEnterAlertAction.send()
    }
    
    alert.addAction(cancelAction)
    alert.addAction(confirmAction)
    present(alert, animated: true)
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
  
  // SearchButton은 textField에 text가 들어오면 파란색으로 color 바뀜
  @objc private func didTapSearchButton() {
    self._didTapSearchButton.send(searchTextField.text ?? "")
  }
  
  @objc private func didTapBackButton() {
    _didTapBackButton.send()
  }
  
  @objc private func editingChangedTextField(_ textField: UITextField) {
    _editingTextField.send(textField.text ?? "")
  }
  
  @objc private func didTapCollectionView() {
    _didTapCollectionView.send()
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
    _didSelectedItem.send(indexPath)
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
    _didTapSearchButton.send(textField.text ?? "")
    return true
  }
}

// MARK: - UserPostSearchHeaderViewDelegate
extension UserPostSearchViewController: UserPostSearchHeaderViewDelegate {
  func didTapDeleteAllButton() {
    _didTapDeleteAllButton.send()
  }
}

// MARK: - SearchTagCellDelegate
extension UserPostSearchViewController: SearchTagCellDelegate {
  func didTapDeleteButton(item: Int, in section: Int) {
    _didTapDeleteButton.send((item, section))
  }
}

// CellLayoutFIXME: - 최근 검색 키워드 충분히 길어진 경우, 잘못된 tag cell size
