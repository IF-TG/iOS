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
  
  // MARK: - Dependencies
  private let viewModel: any SearchMoreDetailViewModel
  
  // MARK: - Properties
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
    $0.register(type: TravelDestinationCell.self)
    $0.register(SearchDetailHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchDetailHeaderView.id)
    $0.roundCorners(cornerRadius: 10,
                    cornerList: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dataSource = self
    $0.bounces = false
    $0.contentInsetAdjustmentBehavior = .never  // 자동 inset 조정 비활성화
  }
  
  private var headerViewHeight: CGFloat {
    self.view.bounds.height * 0.25
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
  
  private let navigationTitleLabel: UILabel = .init().set {
    $0.font = .init(pretendard: .semiBold_600(fontSize: 18))
    $0.textColor = .yg.gray7
    $0.alpha = .zero
  }
  
  private let input = SearchMoreDetailViewModelInput()
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(viewModel: any SearchMoreDetailViewModel) {
    self.viewModel = viewModel
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
    input.viewDidLoad.send()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeNavigationBackground()
  }
}

// MARK: - Bind
extension SearchMoreDetailViewController {
  private func bind() {
    viewModel.transform(input)
      .receive(on: RunLoop.main)
      .sink { [weak self] in
        self?.render($0)
      }
      .store(in: &subscriptions)
  }
  
  func render(_ state: SearchMoreDetailViewModelState) {
    switch state {
    case .reloadDataAndSetHeaderTitle(let title):
      collectionView.reloadData()
      navigationTitleLabel.text = title
      setupBaseNavigationTitleView(titleViewType: .custom(customView: navigationTitleLabel))
    case .reloadItems(let indexPath):
      let indexPath = IndexPath(item: indexPath.item, section: indexPath.section)
      collectionView.reloadItems(at: [indexPath])
    case .none:
      return
    }
  }
}

// MARK: - Actions
extension SearchMoreDetailViewController {
  @objc private func didTapBackBarButtonItem() {
    viewModel.pop()
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailViewController {
  /// 내비게이션의 배경을 제거합니다.
  private func removeNavigationBackground() {
    appearance.backgroundColor = nil
    appearance.shadowColor = nil
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
    self.viewModel.numberOfItemsInSection()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TravelDestinationCell.identifier,
      for: indexPath
    ) as? TravelDestinationCell else { return .init() }
    
    let destinationInfo = viewModel.destinationInfo(indexPath: indexPath)
    cell.configure(with: destinationInfo)
    cell.bind(to: input.didTapStarButton, indexPath: indexPath)
    return cell
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

        headerView.configure(with: viewModel.headerInfo())
      return headerView
    } else { return .init() }
  }
}

// MARK: - UICollectionViewDelegate
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
    navigationItem.standardAppearance = appearance // appearance의 값을 변경 후 standardAppearance에 저장해야 적용됩니다.
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.showDestinationDetail(indexPath: indexPath)
  }
}
