//
//  FeedPostViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/2/23.
//

import UIKit
import Combine

final class FeedPostViewController: UIViewController {
  // MARK: - Properties
  private let postView = PostCollectionView()
    
  private var postViewAdapter: PostViewAdapter?
  
  private var subscription: AnyCancellable?
  
  private var sortingHeader: PostSortingAreaView? {
    let indexPath = IndexPath(item: 0, section: 0)
    return postView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: indexPath
    ) as? PostSortingAreaView
  }
  
  private let refresher = UIRefreshControl()
  
  private let orderFilterNotifier = PassthroughSubject<TravelOrderType, Never>()
  
  private let mainThemeFilterNotifier = PassthroughSubject<TravelMainThemeType, Never>()
  
  private let viewModel: any FeedPostViewModelable & FeedPostViewAdapterDataSource

  private lazy var input = FeedPostViewModel.Input(
    notifiedOrderFilterRequest: orderFilterNotifier,
    notifiedMainThemeFilterRequest: mainThemeFilterNotifier)
  
  // MARK: - Lifecycle
  init(
    type feedCategory: PostCategory,
    viewModel: any FeedPostViewModelable & FeedPostViewAdapterDataSource
  ) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    postView.refreshControl = refresher
    if feedCategory.mainTheme == .all {
      postViewAdapter = PostViewAdapter(dataSource: viewModel, collectionView: postView)
      postViewAdapter?.baseDelegate = self
      return
    }
    postView.register(
      PostSortingAreaView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostSortingAreaView.id)
    updatePostViewLayout()
    postViewAdapter = FeedPostViewAdapter(dataSource: viewModel, collectionView: postView)
    postViewAdapter?.baseDelegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
    input.viewDidLoad.send()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension FeedPostViewController {
  func handleOrderTypeFilter(with orderType: TravelOrderType?) {
    sortingHeader?.setDefaultOrderUI()
    guard let orderType else { return }
    orderFilterNotifier.send(orderType)
  }
  
  func handleMainThemeFilter(with mainTheme: TravelMainThemeType?) {
    sortingHeader?.setDefaultThemeUI()
    guard let mainTheme else { return }
    mainThemeFilterNotifier.send(mainTheme)
  }
}

// MARK: - ViewBindCase
extension FeedPostViewController: ViewBindCase {
  typealias Input = FeedPostViewModel.Input
  typealias ErrorType = Error
  typealias State = FeedPostViewModel.State
  
  func bind() {
    refresher.addTarget(self, action: #selector(refreshNotifications), for: .valueChanged)
    let output = viewModel.transform(input)
    subscription = output.receive(on: DispatchQueue.main).sink { [unowned self] state in
      render(state)
    }
  }
  
  func render(_ state: State) {
    switch state {
    case .refresh:
      postView.reloadData()
      refresher.endRefreshing()
    case .loadingNextPage:
      postView.reloadSections(IndexSet(integer: PostViewSection.bottomRefresh.rawValue))
    case .nextPage(let completion):
      postView.reloadData()
      completion()
    case .unexpectedError(let description):
      // 코디네이터에서 알림창 호출
      print("에러발생 :\(description)")
    case .none:
      break
    case .noMorePage:
      print("noMorePage")
    case .viewDidLoad:
      postView.reloadData()
    case .postFilterLoading:
      startIndicator()
    case .postFilterLoaded:
      stopIndicator()
      postView.reloadData()
    }
  }
  
  func handleError(_ error: ErrorType) { }
}

// MARK: - Private Helpers
extension FeedPostViewController {
  private func updatePostViewLayout() {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(36))
    let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top)
    let tempSection = postView.tempSection.set {
      $0.boundarySupplementaryItems = [headerElement]
    }
    postView.collectionViewLayout = postView.makeLayout(withCustomSection: tempSection)
  }
}

// MARK: - Actions
private extension FeedPostViewController {
  @objc func refreshNotifications() {
    input.feedRefresh.send()
  }
}

// MARK: - PostViewAdapterDelegate
extension FeedPostViewController: PostViewAdapterDelegate {
  func didTapPost(with postId: Int) {
    // 포스트 상세 화면으로 가야함
    //    presenter?.pushViewController(PostDetailViewController(viewModel: PostDetailViewModel()), animated: true)
    // 근데 FeedPostCoordiantor만들어버리자 그냥;
  }
  
  func scrollToNextPage() {
    input.nextPage.send()
  }
}

// MARK: - LayoutSupport
extension FeedPostViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(postView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      postView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      postView.topAnchor.constraint(equalTo: view.topAnchor),
      postView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      postView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
  }
}
