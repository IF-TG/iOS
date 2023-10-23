//
//  FeedPostViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/2/23.
//

import UIKit
import Combine

struct FeedPostViewControllerInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
}

enum FeedPostViewControllerState {
  case updatePosts
  case none
}

final class FeedPostViewController: UIViewController {
  enum Constant {
    static let postViewSortingHeaderHeight: CGFloat = 36
  }
  
  // MARK: - Properties
  private let postView = PostCollectionView()
  
  private let viewModel: any FeedPostViewModelable
  
  private var postViewAdapter: PostViewAdapter!
  
  private var subscription: AnyCancellable?
  
  private let input = Input()
  
  override func loadView() {
    view = postView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Lifecycle
  init(with filterInfo: FeedPostSearchFilterInfo) {
    let viewModel = FeedPostViewModel(filterInfo: filterInfo, postUseCase: MockPostUseCase())
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    bind()
    if filterInfo.travelTheme == .all {
      postViewAdapter = PostViewAdapter(dataSource: viewModel, collectionView: postView)
      return
    }
    updatePostViewLayout()
    postView.register(
      PostSortingAreaView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostSortingAreaView.id)
    postViewAdapter = FeedPostViewAdapter(dataSource: viewModel, collectionView: postView)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
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
    case .none:
      break
    case .updatePosts:
      postView.reloadData()
    }
  }
  
  func handleError(_ error: ErrorType) { }
}

// MARK: - Private Helpers
extension FeedPostViewController {
  private func configureUI() {
    view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func updatePostViewLayout() {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(Constant.postViewSortingHeaderHeight))
    let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top)
    var tempSection = postView.tempSection.set {
      $0.boundarySupplementaryItems = [headerElement]
    }
    postView.collectionViewLayout = postView.makeLayout(withCustomSection: tempSection)
  }
}
