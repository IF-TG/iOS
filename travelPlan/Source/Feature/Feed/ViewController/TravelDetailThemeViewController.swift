//
//  TravelDetailThemeViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/2/23.
//

import UIKit
import Combine

final class TravelDetailThemeViewController: UIViewController {
  // MARK: - Properties
  // TODO: - PostView 헤더에 소팅 뷰 추가할건지 여기에 추가할건지 정해야함.
  
  //  private lazy var postSortingMenuAreaView = PostSortingMenuAreaView(
  //    travelThemeType: )
  
  private let postView = PostCollectionView()
  
  private var viewModel: PostViewModel!
  
  private var postViewAdapter: PostViewAdapter!
  
  private var subscription: AnyCancellable?
  
  override func loadView() {
    view = postView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Lifecycle
  init(with filterInfo: FeedPostSearchFilterInfo) {
    super.init(nibName: nil, bundle: nil)
    // TODO: - FilterInfo를 기반으로한 vm만들어야합니다.
    // viewModel = PostViewModel(filterInfo: filterInfo)
    viewModel = PostViewModel(postUseCase: MockPostUseCase())
    postViewAdapter = PostViewAdapter(dataSource: viewModel, collectionView: postView)
    subscription = viewModel.$posts.receive(on: DispatchQueue.main).sink { [weak self] _ in
      self?.postView.reloadData()
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

// MARK: - Private Helpers
extension TravelDetailThemeViewController {
  private func configureUI() {
    view.translatesAutoresizingMaskIntoConstraints = false
  }
}
