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
  
  private var subscriptions = Set<AnyCancellable>()
  
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
  
  private var postOptionViewModel: any PostOptionViewModelable & PostOptionViewModelPageDelegate

  private lazy var input = FeedPostViewModelInput(
    notifiedOrderFilterRequest: orderFilterNotifier,
    notifiedMainThemeFilterRequest: mainThemeFilterNotifier)
  
  private let postOptionInput = PostOptionViewModelInput()
  
  weak var coordinator: FeedPostCoordinatorDelegate?
  
  // MARK: - Lifecycle
  init(
    type feedCategory: PostCategory,
    viewModel: any FeedPostViewModelable & FeedPostViewAdapterDataSource,
    postOptionViewModel: any PostOptionViewModelable & PostOptionViewModelPageDelegate
  ) {
    self.viewModel = viewModel
    self.postOptionViewModel = postOptionViewModel
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
    viewModel
      .transform(input)
      .receive(on: RunLoop.current)
      .sink { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
    
    postOptionViewModel
      .transform(postOptionInput)
      .receive(on: RunLoop.current)
      .sink { [weak self] optionState in
        self?.render(optionState)
      }.store(in: &subscriptions)
  }
  
  func render(_ state: PostOptionViewModelState) {
    switch state {
    case .none:
      stopIndicator()
    case .networkProcessing:
      startIndicator()
    case .completeReport, .completeUserBlock:
      stopIndicator()
      postOptionViewModel.showPostReportResult()
    case .unexpectedError(let description):
      postOptionViewModel.showAlertForError(with: description, completion: nil)
    }
  }
  
  func render(_ state: State) {
    switch state {
    case .refresh:
      postView.reloadData()
      refresher.endRefreshing()
    case .pagination(let paginationState):
      handlePaginationState(paginationState)
    case .unexpectedError(let description):
      // 코디네이터에서 알림창 호출
      print("에러발생 :\(description)")
    case .none:
      break
    case .viewDidLoad:
      stopIndicator()
      postView.reloadData()
      print("피드 포스트 viewDidLoad")
    case .networking:
      startIndicator()
    case .postFilterLoaded:
      postView.reloadData()
      stopIndicator()
    case .detailPostShow(let post):
      coordinator?.showDetailPost(post: post) { [weak self] blockedPostId in
        self?.input.postBlockSubject.send(blockedPostId)
      }
    case .deleteBlockedPost(let deletedIndexPath):
      postView.performBatchUpdates {
        postView.deleteItems(at: [deletedIndexPath])
      }
    case .share(let title, let postId):
      let item = PostActivityItemSource(title: title, postId: postId)
      let activityItems: [Any] = [item]
      
      coordinator?.showPostShare(with: activityItems)
    case .completePostBlock:
      coordinator?.showCompleteionPostBlocking()
      stopIndicator()
    }
  }
  
  func handlePaginationState(_ state: FeedPostViewModelPaginationState) {
    switch state {
    case .nextPage(let reloadCompletion):
      postView.reloadData()
      reloadCompletion()
    case .loadingNextPage:
      postView.reloadSections(IndexSet(integer: PostViewSection.bottomRefresh.rawValue))
    case .noMorePage:
      stopIndicator()
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
  func share(_ cell: UICollectionViewCell) {
    guard let indexPath = postView.indexPath(for: cell) else { return }
    input.postShareSubject.send(indexPath)
  }
  
  func tapOption(_ cell: UICollectionViewCell) {
    guard let indexPath = postView.indexPath(for: cell) else { return }
    let postInfo = viewModel.postInfoForPostOption(from: indexPath)
    postOptionInput.postInfoSubject.send(postInfo)
    postOptionViewModel.showPostOption()
  }
  
  func tapHeart(_ cell: UICollectionViewCell) {
    // TODO: - 하트, input 로직 추가해야합니다.
    print("피드 포스트 하트 클릭")
  }
  
  func didTapPost(with postIndex: Int) {
    input.specificPostTapped.send(postIndex)
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
