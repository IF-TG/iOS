//
//  FeedViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit
import Combine

final class FeedViewController: UIViewController {
  // MARK: - Properties
  private let categoryPageView = CategoryPageView()
  
  lazy var input = Input(
    didTapPostSearch: searchBarItem.tap,
    didTapNotification: notificationBarItem.tap)
 
  private let leftNaviBarItem = FeedAppTitleBarItem()
  
  private let searchBarItem = FeedPostSearchBarItem()
  
  private let notificationBarItem = FeedNotificationBarItem()
  
  private let vm = FeedViewModel()
  
  private var subscription = Set<AnyCancellable>()
  
  private var naviConstraints: [NSLayoutConstraint] = []
  
  // MARK: - LifeCycle
  override func viewWillAppear(_ animated: Bool) {
    input.appear.send()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Helpers
extension FeedViewController {
  // redEffectTODO: - 사용자가 확인하지 않은 알림이 있을 경우 아래 코드 호출해서 빨간 알림 이펙트 추가해야합니다.
  // notificationBarItem.updateIsCheckedNotification(.notChecked)
  private func configureUI() {
    configureFeedNavigationBar()
    setupUI()
    bind()
    view.backgroundColor = .white
  }
  
  private func configureFeedNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNaviBarItem)
    let rightSearchBarItem = UIBarButtonItem(customView: searchBarItem)
    let rightNotificationBarItem = UIBarButtonItem(customView: notificationBarItem)
    navigationItem.rightBarButtonItems = [rightNotificationBarItem, rightSearchBarItem]
  }
}

// MARK: - ViewBindCase
extension FeedViewController: ViewBindCase {
  typealias Input = FeedViewModel.Input
  typealias ErrorType = FeedViewModel.ErrorType
  typealias State = FeedViewModel.State
  
  func bind() {
    let output = vm.transform(input)
    
    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        switch result {
        case .finished:
          break
        case .failure(let error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] in self?.render($0) }
      .store(in: &subscription)
  }
  
  func render(_ state: State) {
    switch state {
    case .none:
      break
    case .viewAppear(let value):
      notificationBarItem.updateNotificationRedIcon(value)
    case .updateNotificationRedIcon:
      // 알림TODO: - 알림 온 경우. feedVM에서 1~5초 간격으로 알림이 왔는지 여부를 확인합니다.
      notificationBarItem.updateNotificationRedIcon(.notChecked)
    case .goToPostSearch:
      let vc = UserPostSearchViewController(nibName: nil, bundle: nil)
      navigationController?.pushViewController(vc, animated: true)
    case .goToNotification:
      // transitionTODO: - Goto notifiation with naivgationController
      notificationBarItem.updateNotificationRedIcon(.none)
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .none:
      break
    }
  }
}

// MARK: - LayoutSupport
extension FeedViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(categoryPageView)
  }

  func setConstraints() {
    NSLayoutConstraint.activate(categoryPageViewConstraint)
  }
}

fileprivate extension FeedViewController {
  var categoryPageViewConstraint: [NSLayoutConstraint] {
    [categoryPageView.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor),
     categoryPageView.leadingAnchor.constraint(
      equalTo: view.leadingAnchor),
     categoryPageView.trailingAnchor.constraint(
      equalTo: view.trailingAnchor),
     categoryPageView.bottomAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
}
