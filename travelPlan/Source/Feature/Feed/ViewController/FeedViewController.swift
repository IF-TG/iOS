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
 
  private let leftNaviBarItem = FeedAppTitleBarItem()
    
  /// 사용자가 알림을 확인 했는지 여부를 체크하고 이에 따른 notificationIcon 상태를 rendering 합니다.
  private var isCheckedNotification: Bool?
  
  private let vm = FeedViewModel()
  
  private var subscription = Set<AnyCancellable>()

  private let tapPostSearch = PassthroughSubject<Void, FeedViewModelError>()
  
  private let tapNotification = PassthroughSubject<Void, FeedViewModelError>()
  
  private let appear = PassthroughSubject<Void, FeedViewModelError>()
  
  private var naviConstraints: [NSLayoutConstraint] = []
  
  // MARK: - Lifecycle
  override func viewWillAppear(_ animated: Bool) {
    appear.send()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Helpers
extension FeedViewController {
  private func configureUI() {
    configureFeedNavigationBar()
    setupUI()
    bind()
    view.backgroundColor = .white
  }
  
  private func configureFeedNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNaviBarItem)
    let feedSearchBarItem = FeedPostSearchBarItem()
    feedSearchBarItem.delegate = self
    let feedNotificationBarItem =
    FeedNotificationBarItem()
    feedNotificationBarItem.delegate = self
    let rightSearchBarItem = UIBarButtonItem(customView: feedSearchBarItem)
    let rightNotificationBarItem = UIBarButtonItem(customView: feedNotificationBarItem)
    navigationItem.rightBarButtonItems = [rightNotificationBarItem, rightSearchBarItem]
    
  }
}

// MARK: - ViewBindCase
extension FeedViewController: ViewBindCase {
  typealias State = FeedViewControllerState
  
  func bind() {
    let input = FeedViewControllerEvent(
      appear: appear.eraseToAnyPublisher(),
      didTapPostSearch: tapPostSearch.eraseToAnyPublisher(),
      didTapNotification: tapNotification.eraseToAnyPublisher())
    let output = vm.transform(input)
    
    output
      .receive(on: RunLoop.main)
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
    case .initFeedNaviBarIsCheckedNotification(let value):
      print(value)
      rightNaviBarItem.updateIsCheckedNotification(value)
    case .updateNotificationRedIcon:
      rightNaviBarItem.updateIsCheckedNotification(false)
    case .goToPostSearch:
      let vc = UserPostSearchViewController(nibName: nil, bundle: nil)
      navigationController?.pushViewController(vc, animated: true)
    case .goToNotification(let isChecked):
      // goto notifiation with naivgationController
      print("DEBUG: User notification event occured")
      rightNaviBarItem.updateIsCheckedNotification(isChecked)
    }
  }
  
  func handleError(_ error: FeedViewModelError) {
    switch error {
    case .none:
      break
    }
  }
}

// MARK: - FeedNavigationBarDelegate
extension FeedViewController: FeedNavigationBarDelegate {
  func didTapPostSearch() {
    tapPostSearch.send()
  }

  func didTapNotification() {
    print("hiss")
    tapNotification.send()
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
