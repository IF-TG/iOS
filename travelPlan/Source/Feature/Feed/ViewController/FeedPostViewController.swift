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
  
  var themeType: PostSearchFilterType {
    viewModel.headerItem
  }
  
  private let input = Input()
  
  weak var delegate: FeedPostViewControllerDelegate?
  
  // MARK: - Lifecycle
  init(with filterInfo: FeedPostSearchFilterInfo) {
    let viewModel = FeedPostViewModel(filterInfo: filterInfo, postUseCase: MockPostUseCase())
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    if filterInfo.travelTheme == .all {
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
    view.addSubview(postView)
    NSLayoutConstraint.activate([
      postView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      postView.topAnchor.constraint(equalTo: view.topAnchor),
      postView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      postView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    bind()
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

// MARK: - PostViewAdapterDelegate
extension FeedPostViewController: PostViewAdapterDelegate {
  func didTapPost(with postId: Int) {
    delegate?.didTapPost(with: postId)
  }
  
  func didTapHeart(in cell: UICollectionViewCell) {
    guard let indexPath = postView.indexPath(for: cell) else { return }
    let item = viewModel.postItem(at: indexPath.row)
    // TODO: - 뷰모델을 통해 하트 증가 서버에 호출
  }
  
  func didTapComment(in cell: UICollectionViewCell) {
    guard let indexPath = postView.indexPath(for: cell) else { return }
    let item = viewModel.postItem(at: indexPath.row)
    delegate?.didTapComment(with: item.postId)
  }
  
  func didTapShare(in cell: UICollectionViewCell) {
    guard let indexPath = postView.indexPath(for: cell) else { return }
    let item = viewModel.postItem(at: indexPath.row)
    let renderer = UIGraphicsImageRenderer(size: cell.bounds.size)
    let image = renderer.image { context in
      cell.layer.render(in: context.cgContext)
    }
    
    delegate?.didTapShare(
      with: item.postId,
      title: item.header.contentInfo.title,
      contentImage: image)
  }
  
  func didTapOption(in cell: UICollectionViewCell) {
    guard let indexPath = postView.indexPath(for: cell) else { return }
    let item = viewModel.postItem(at: indexPath.row)
    delegate?.didTapOption(with: item.postId)
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
  private func updatePostViewLayout() {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(Constant.postViewSortingHeaderHeight))
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
