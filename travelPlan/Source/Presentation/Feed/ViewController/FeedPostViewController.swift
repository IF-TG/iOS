//
//  FeedPostViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/2/23.
//

import UIKit
import Combine

struct FeedPostViewControllerInput {
  let feedRefresh: PassthroughSubject<Void, Never> = .init()
  let nextPage: PassthroughSubject<Void, Never> = .init()
}

enum FeedPostViewControllerState {
  case refresh
  case networkProcessing
  case nextPage
  case unexpectedError(description: String)
  case none
}

final class FeedPostViewController: UIViewController {
  // MARK: - Properties
  private let postView = PostCollectionView()
  
  private let viewModel: any FeedPostViewModelable & FeedPostViewAdapterDataSource
    
  private var postViewAdapter: PostViewAdapter?
  
  private var subscription: AnyCancellable?
  
  private var sortingHeader: PostSortingAreaView? {
    let indexPath = IndexPath(item: 0, section: 0)
    return postView.supplementaryView(
      forElementKind: UICollectionView.elementKindSectionHeader,
      at: indexPath
    ) as? PostSortingAreaView
  }

  private let input = Input()
  
  // MARK: - Lifecycle
  // 아.. 포스트 델리겡티터? 얘를통해서 FeedVC에서 postDetail 프레젠테이션해주네,, 이거말고 여기서 할수는 없나??
  // TODO: - 3.20.12시. 해야할것:  이제 스크롤할 때마다 20 maxCount 넘는경우 nextPage전달해줘야함.
  // 그리고 postCategory도 이거 VM내부에서 init시점에 받도록 리빌딩해야함. 포스트 딜리게이터도 여기 내부에서 처리해도 될듯?
  // 스크롤 시점에 스크롤 높이 측정해서 content scroll범위보다 큰지 파악 후 nextpage input날려야함.
  init(with postCategory: PostCategory) {
    // TODO: - Coordinator로 빼야함
    let postUseCase = DefaultPostUseCase(postRepository: MockPostRepository())
    let viewModel = FeedPostViewModel(postCategory: postCategory, postUseCase: postUseCase)
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    if postCategory.mainTheme == .all {
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
    input.nextPage.send()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension FeedPostViewController {
  func setDefaultThemeUI() {
    sortingHeader?.setDefaultThemeUI()
  }
  
  func setDefaultOrderUI() {
    sortingHeader?.setDefaultOrderUI()
  }
}

// MARK: - ViewBindCase
extension FeedPostViewController: ViewBindCase {
  typealias Input = FeedPostViewControllerInput
  typealias ErrorType = Error
  typealias State = FeedPostViewControllerState
  
  func bind() {
    let output = viewModel.transform(input)
    subscription = output.receive(on: DispatchQueue.main).sink { [unowned self] state in
      render(state)
    }
  }
  
  func render(_ state: FeedPostViewControllerState) {
    switch state {
//    case .updatePosts:
//      postView.reloadData()
    case .refresh:
      // stopIndicator()
      postView.reloadData()
    case .networkProcessing:
      // startIndicator()
      break
    case .nextPage:
      postView.reloadData()
    case .unexpectedError(let description):
      print("에러발생 :\(description)")
    case .none:
      break
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

// MARK: - PostViewAdapterDelegate
extension FeedPostViewController: PostViewAdapterDelegate {
  func didTapPost(with postId: Int) {
    // 포스트 상세 화면으로 가야함
    //    presenter?.pushViewController(PostDetailViewController(viewModel: PostDetailViewModel()), animated: true)
    // 근데 FeedPostCoordiantor만들어버리자 그냥;
  }
  
  func scrollToNextPage() {
    
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
