//
//  SearchMoreDetailViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit
import SnapKit
import Combine

class SearchMoreDetailViewController: UIViewController {
  enum Constants {
    enum CollectionView {
      static let cornerRadius: CGFloat = 10
    }
    enum CollectionHeaderView {
      static let heightRatio: CGFloat = 0.25
    }
    enum CollectionViewCell {
      static let height: CGFloat = UIScreen.main.bounds.height * 0.172
    }
  }
  
  // MARK: - Properties
  weak var coordinator: SearchMoreDetailCoordinatorDelegate?
  private let viewModel = SearchMoreDetailViewModel()
  
  private let compositionalLayoutManager: CompositionalLayoutCreatable = SearchMoreDetailLayoutManager()
  
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: compositionalLayoutManager.makeLayout()
  ).set {
    self.registerCell(in: $0)
    $0.register(SearchDetailHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchDetailHeaderView.id)
    $0.roundCorners(cornerRadius: Constants.CollectionView.cornerRadius,
                    cornerList: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    $0.backgroundColor = .white
    $0.delegate = self
    $0.dataSource = self
    $0.bounces = false
    $0.contentInsetAdjustmentBehavior = .never  // 자동 inset 조정 비활성화
  }
  
  private var headerViewHeight: CGFloat {
    self.view.bounds.height * Constants.CollectionHeaderView.heightRatio
  }
  
  private lazy var backButton: UIButton = .init().set {
    $0.addTarget(
      self,
      action: #selector(didTapBackBarButtonItem),
      for: .touchUpInside
    )
    $0.contentEdgeInsets = .init(
      top: .zero,
      left: 10,
      bottom: .zero,
      right: .zero
    )
    $0.setImage(
      UIImage(named: "back")?
        .withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    $0.imageView?.tintColor = .white
  }
  
  private let type: SearchSectionType
  
  private let input = Input()
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(type: SearchSectionType) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    coordinator?.finish()
    print("deinit: \(Self.self)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bind()
    input.viewDidLoad.send(type)
    
    switch type {
    case .festival:
      print("베스트 축제 VC")
    case .camping:
      print("레포츠 vc")
    case .topTen:
      print("여행지 TOP 10 VC")
    }
  }
}

extension SearchMoreDetailViewController: ViewBindCase {
  typealias Input = SearchMoreDetailViewModel.Input
  typealias ErrorType = SearchMoreDetailViewModel.ErrorType
  typealias State = SearchMoreDetailViewModel.State
  
  func bind() {
    let output = viewModel.transform(input)
    output
      .receive(on: RunLoop.main)
      .sink { [weak self] result in
        switch result {
        case .failure(let error):
          self?.handleError(error)
        case .finished:
          print("finished \(Self.self)")
        }
      } receiveValue: { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  func render(_ state: SearchMoreDetailViewModel.State) {
    switch state {
    case .showDetailVC:
      print("DEBUG: show detail")
    case .none:
      break
    }
  }
  
  func handleError(_ error: SearchMoreDetailViewModel.ErrorType) {
    switch error {
    case .unexpected:
      print("DEBUG: unexpected error")
    case .none:
      break
    }
  }
}

// MARK: - Actions
extension SearchMoreDetailViewController {
  @objc private func didTapBackBarButtonItem() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailViewController {
  private func setupStyles() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationBar() {
    self.navigationController?.isNavigationBarHidden = false
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    clearNavigationBarImage()
  }
  
  private func clearNavigationBarImage() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func changeBlackOrWhiteColor(with alpha: CGFloat) -> UIColor {
    return UIColor(white: alpha, alpha: 1)
  }
  
  private func registerCell(in collectionView: UICollectionView) {
    switch type {
    case .festival, .camping:
      collectionView.register(TravelDestinationCell.self,
                              forCellWithReuseIdentifier: TravelDestinationCell.id)
    case .topTen:
      collectionView.register(SearchTopTenCell.self, 
                              forCellWithReuseIdentifier: SearchTopTenCell.id)
    }
  }
}

// MARK: - LayoutSupport
extension SearchMoreDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(collectionView)
  }
  
  func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchMoreDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    self.viewModel.numberOfItems(type: type)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    switch type {
    case .festival, .camping:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TravelDestinationCell.id,
        for: indexPath
      ) as? TravelDestinationCell else { return .init() }
      guard let cellViewModels = self.viewModel.travelDestinationCellViewModels else { return .init() }
      
      cell.configure(with: cellViewModels[indexPath.item])
      return cell
      
    case .topTen:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SearchTopTenCell.id,
        for: indexPath
      ) as? SearchTopTenCell else { return .init() }
      guard let cellViewModels = self.viewModel.topTenCellViewModels else { return .init() }
      
      cell.configure(with: cellViewModels[indexPath.item])
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
        withReuseIdentifier: SearchDetailHeaderView.id,
        for: indexPath
      ) as? SearchDetailHeaderView else { return .init() }
      
      if let headerInfo = viewModel.headerInfo {
        headerView.configure(with: headerInfo)
      }
      return headerView
    } else { return .init() }
  }
}

extension SearchMoreDetailViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let maxHeight = min(headerViewHeight, scrollView.contentOffset.y)
    
    let alpha = (headerViewHeight - maxHeight) / headerViewHeight
    let headerView = collectionView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: .zero, section: .zero)
    )
    
    headerView?.alpha = alpha
    backButton.imageView?.tintColor = changeBlackOrWhiteColor(with: alpha)
  }
}
