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
    image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate),
    style: .plain,
    target: self,
    action: #selector(didTapSearchButton)
  ).set {
    $0.isEnabled = false
    $0.tintColor = .yg.gray1
  }
  
  private lazy var backButtonItem = UIBarButtonItem(
    image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: self,
    action: #selector(didTapBackButton)
  )
  
  private lazy var searchTextField: UITextField = UITextField().set {
    $0.attributedPlaceholder = .init(
      string: "여행자들의 여행 리뷰를 검색해보세요.",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.yg.gray1]
    )
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
    
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dataSource = self
    
    $0.register(
      PostSearchTagCell.self,
      forCellWithReuseIdentifier: PostSearchTagCell.id
    )
    $0.register(
      PostSearchHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostSearchHeaderView.id
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    coordinator?.finish()
  }
  
  deinit {
    print("DEBUG: \(String(describing: self)) deinit")
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
      showAlert(alertType: .withCancel, message: "최근 검색 내역을\n모두 삭제하시겠습니까?", target: self)
    case .deleteCell(let section), .deleteAllCells(let section):
      collectionView.reloadSections(IndexSet(section...section))
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
        $0.width.equalTo(260)
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

// MARK: - UICollectionViewDelegateFlowLayout
extension PostSearchViewController: UICollectionViewDelegateFlowLayout {
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
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let tagCell = cell as? PostSearchTagCell else { return }
    tagCell.setBackgroundColor(with: indexPath.section)
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
    return viewModel.numberOfItemsInSection(section)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let tagCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PostSearchTagCell.id,
      for: indexPath
    ) as? PostSearchTagCell else { return UICollectionViewCell() }
    
    tagCell.delegate = self
    
    let tagString = viewModel.fetchTagString(tagCell, at: indexPath)
    tagCell.configure(tagString)
    return tagCell
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
        withReuseIdentifier: PostSearchHeaderView.id,
        for: indexPath
      ) as? PostSearchHeaderView else { return UICollectionReusableView() }
      
      titleHeaderView.delegate = self
      
      let titleString = viewModel.fetchHeaderTitle(titleHeaderView, in: indexPath.section)
      titleHeaderView.prepare(title: titleString)
      
      return titleHeaderView
      // FooterView
    case UICollectionView.elementKindSectionFooter:
      guard let lineFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: PostSearchFooterView.id,
        for: indexPath
      ) as? PostSearchFooterView else { return UICollectionReusableView() }
      
      if viewModel.isRecentSection(in: indexPath.section) {
        lineFooterView.isHidden = true
      }
      
      return lineFooterView
    default: return UICollectionReusableView()
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

// MARK: - PostSearchTagCellDelegate
extension PostSearchViewController: PostSearchTagCellDelegate {
  func didTapDeleteButton(item: Int, in section: Int) {
    input.didTapDeleteButton.send((item, section))
  }
}

// MARK: - CautionAlertViewControllerDelegate
extension PostSearchViewController: CautionAlertViewControllerDelegate {
  func didTapAlertConfirm() {
    input.didTapAlertConfirmButton.send()
  }
  
  func didTapAlertCancel() {
    input.didTapAlertCancelButton.send()
  }
}
// CellLayoutFIXME: - 최근 검색 키워드 충분히 길어진 경우, 잘못된 tag cell size
