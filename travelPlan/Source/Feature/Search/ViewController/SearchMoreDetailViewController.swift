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
  enum Constant {
    enum CollectionView {
      static let cornerRadius: CGFloat = 10
    }
    enum CollectionHeaderView {
      static let heightRatio: CGFloat = 0.25
    }
    enum CollectionViewCell {
      static let height: CGFloat = UIScreen.main.bounds.height * 0.172
    }
    enum BackButton {
      enum ContentEdgeInsets {
        static let left: CGFloat = 10
      }
      static let imageName = "back"
    }
    enum NavigationTitleLabel {
      static let maxAlpha: CGFloat = 1
      static let fontSize: CGFloat = 18
    }
  }
  
  // MARK: - Properties
  weak var coordinator: SearchMoreDetailCoordinatorDelegate?
  private let viewModel = SearchMoreDetailViewModel()
  private let appearance = UINavigationBarAppearance()
  private let compositionalLayoutManager: CompositionalLayoutCreatable = SearchMoreDetailLayoutManager()
  private lazy var compositionalLayout = compositionalLayoutManager.makeLayout()
    .set {
    $0.register(InnerRoundRectReusableView.self, forDecorationViewOfKind: InnerRoundRectReusableView.baseID)
  }
  
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: compositionalLayout
  ).set {
    self.registerCell(in: $0)
    $0.register(SearchDetailHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchDetailHeaderView.id)
    $0.roundCorners(cornerRadius: Constant.CollectionView.cornerRadius,
                    cornerList: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dataSource = self
    $0.bounces = false
    $0.contentInsetAdjustmentBehavior = .never  // 자동 inset 조정 비활성화
  }
  
  private var headerViewHeight: CGFloat {
    self.view.bounds.height * Constant.CollectionHeaderView.heightRatio
  }
  
  private lazy var backButton: UIButton = .init().set {
    typealias Const = Constant.BackButton
    $0.addTarget(
      self,
      action: #selector(didTapBackBarButtonItem),
      for: .touchUpInside
    )
    $0.contentEdgeInsets = .init(
      top: .zero,
      left: Const.ContentEdgeInsets.left,
      bottom: .zero,
      right: .zero
    )
    $0.setImage(
      UIImage(named: Const.imageName)?
        .withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    $0.imageView?.tintColor = .white
  }
  
  private let navigationTitleLabel: UILabel = .init().set {
    typealias Const = Constant.NavigationTitleLabel
    $0.font = .init(pretendard: .semiBold_600, size: Const.fontSize)
    $0.textColor = .yg.gray7
    $0.alpha = .zero
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
    print("deinit: \(Self.self)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
    setupNavigationBar()
    bind()
    input.viewDidLoad.send(type)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeNavigationBackground()
    setNavigationBarAppearance(with: appearance)
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
    case .showDetail:
      print("DEBUG: 다음 화면으로 전환합니다.")
    case let .setNavigationTitle(title):
      navigationTitleLabel.text = title
      setupBaseNavigationTitleView(titleViewType: .custom(customView: navigationTitleLabel))
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
    coordinator?.finish(withAnimated: true)
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailViewController {
  /// 내비게이션의 배경을 제거합니다.
  private func removeNavigationBackground() {
    appearance.backgroundColor = nil
    appearance.shadowColor = nil
  }
  
  /// appearance의 값을 변경 후, 해당 함수를 호출해야만 변경된 값이 적용됩니다.
  private func setNavigationBarAppearance(with appearance: UINavigationBarAppearance) {
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }
  
  private func setupStyles() {
    view.backgroundColor = .yg.gray00Background
  }
  
  private func setupNavigationBar() {
    self.navigationController?.isNavigationBarHidden = false
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
  
  /// scaleFactor는 0과 1사이의 조절 변수입니다.
  ///
  /// scaleFactor가 1에서 0으로 변하면, color가 white에서 black으로 변합니다.
  /// 반대로 scaleFactor가 0에서 1로 변하면, color가 black에서 white로 변합니다.
  private func changeBackButtonTintColor(with scaleFactor: CGFloat) -> UIColor {
    return UIColor(white: scaleFactor, alpha: 1)
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
    guard let headerView = self.collectionView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: IndexPath(item: .zero, section: .zero)
    ) else { return }
    
    guard
      let navigationBarHeight = self.navigationController?.navigationBar.bounds.height,
      let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height
    else { return }
    
    // headerView 높이
    let headerViewHeight = headerView.bounds.height
    // bar 높이
    let appearanceHeight = navigationBarHeight + statusBarHeight
    
    let heightDistance = headerViewHeight - appearanceHeight
    let maxHeight = min(heightDistance, scrollView.contentOffset.y)
    let headerViewAlpha = (heightDistance - maxHeight) / heightDistance
    
    // 헤더뷰의 bottom이 내비게이션바의 botom과 닿거나 헤더뷰의 bottom이 내비게이션바의 bottom보다 위에 존재하는 경우
    if scrollView.contentOffset.y >= heightDistance {
      appearance.backgroundColor = .white
      appearance.shadowColor = .yg.gray0
      navigationTitleLabel.alpha = Constant.NavigationTitleLabel.maxAlpha
    } else {
      removeNavigationBackground()
      navigationTitleLabel.alpha = .zero
    }
    
    headerView.alpha = headerViewAlpha
    appearance.backgroundEffect = .none // 내비게이션 반투명도 제거
    backButton.imageView?.tintColor = changeBackButtonTintColor(with: headerViewAlpha)
    setNavigationBarAppearance(with: appearance)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    input.didSelectItem.send(indexPath)
  }
}
