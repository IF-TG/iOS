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
  
  private var feedNavigationBar = FeedNavigationBar(isCheckedNotification: nil)
  
  private let vm = FeedViewModel()
  
  private var subscription = Set<AnyCancellable>()

  private let tapPostSearch = PassthroughSubject<Void, FeedViewModelError>()
  
  private let tapNotification = PassthroughSubject<Void, FeedViewModelError>()
  
  private let appear = PassthroughSubject<Void, FeedViewModelError>()
  
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
    view.backgroundColor = .white
    bind()
  }
  private func configureFeedNavigationBar() {
    guard let naviBar = navigationController?.navigationBar else { return }
    feedNavigationBar.delegate = self
    feedNavigationBar.layoutFrom(naviBar)
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
      feedNavigationBar.updateIsCheckedNotification(value)
    case .updateNotificationRedIcon:
      feedNavigationBar.updateIsCheckedNotification(false)
    case .goToPostSearch:
      // goto user post search naivgationController
      print("DEBUG: User post search event occured")
    case .goToNotification(let isChecked):
      // goto notifiation with naivgationController
      print("DEBUG: User notification event occured")
      feedNavigationBar.updateIsCheckedNotification(isChecked)
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
