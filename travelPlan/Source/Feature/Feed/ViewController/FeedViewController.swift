//
//  FeedViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit
import Combine

final class FeedViewController: UIViewController {
  enum Constant {
    enum ReviewWriteButton {
      static let size: CGSize = .init(width: 60, height: 60)
      static let iconSize: CGSize = .init(width: 28, height: 28)
      static let iconName = "feedPlus"
      enum Spacing {
        static let trailing: CGFloat = 16
        static let bottom = trailing
      }
    }
  }
  
  // MARK: - Properties
  weak var coordinator: FeedCoordinatorDelegate?
  
  private let categoryPageView = CategoryPageView()
  
  lazy var input = Input(
    didTapPostSearch: searchBarItem.tap,
    didTapNotification: notificationBarItem.tap,
    didTapReviewWrite: reviewWriteButtonPublihser)
 
  private let leftNaviBarItem = FeedAppTitleBarItem()
  
  private let searchBarItem = FeedPostSearchBarItem()
  
  private let notificationBarItem = FeedNotificationBarItem()
  
  private let vm = FeedViewModel()
  
  private var subscription = Set<AnyCancellable>()
  
  private var naviConstraints: [NSLayoutConstraint] = []
  
  private var reviewWriteButton = UIButton(frame: .zero).set {
    typealias Const = Constant.ReviewWriteButton
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.primary
    $0.layer.cornerRadius = Const.size.width/2
    guard let image = UIImage(named: Const.iconName) else { return }
    $0.setImage(image, for: .normal)
  }
  
  private var reviewWriteButtonPublihser: AnyPublisher<Void, Never> {
    reviewWriteButton.tap.map {
      self.reviewWriteButton.backgroundColor = .yg.primary.withAlphaComponent(0.75)
    }.eraseToAnyPublisher()
  }
  
  // MARK: - LifeCycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    input.appear.send()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  deinit {
    coordinator?.finish()
  }
}

// MARK: - Private helpers
extension FeedViewController {
  // redEffectTODO: - 사용자가 확인하지 않은 알림이 있을 경우 아래 코드 호출해서 빨간 알림 이펙트 추가해야합니다.
  // notificationBarItem.updateIsCheckedNotification(.notChecked)
  private func configureUI() {
    configureFeedNavigationBar()
    setupUI()
    bind()
    view.backgroundColor = .white
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleNotificaiton),
      name: .TravelCategoryDetailSelected,
      object: nil)
    setReviewWriteButtonShadow()
    navigationBackgroundView()
  }
  
  private func navigationBackgroundView() {
    _=UIView(frame: .zero).set {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .white
      NSLayoutConstraint.activate([
        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        $0.topAnchor.constraint(equalTo: view.topAnchor),
        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
    }
  }
  
  private func configureFeedNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftNaviBarItem)
    let rightSearchBarItem = UIBarButtonItem(customView: searchBarItem)
    let rightNotificationBarItem = UIBarButtonItem(customView: notificationBarItem)
    navigationItem.rightBarButtonItems = [rightNotificationBarItem, rightSearchBarItem]
  }
  
  private func setReviewWriteButtonShadow() {
    typealias Const = Constant.ReviewWriteButton
    let rect = CGRect(x: 0, y: 0, width: Const.size.width, height: Const.size.height)
    let path = UIBezierPath(roundedRect: rect, cornerRadius: 30)
    reviewWriteButton.layer.shadowRadius = 10
    reviewWriteButton.layer.shadowOpacity = 1
    reviewWriteButton.layer.shadowOffset = .init(width: 0, height: 4)
    reviewWriteButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    reviewWriteButton.layer.shadowPath = path.cgPath
  }
}

// MARK: - Action
extension FeedViewController {
  @objc func handleNotificaiton(_ noti: Notification) {
    let notiKey = Notification.Name.TravelCategoryDetailSelected
    guard
      let type = noti.userInfo?[notiKey] as? TravelCategorySortingType
    else {
      NSLog("DEBUG: 데이터 못받았어... feedVC에서 from MoreCategoryView..")
      return
    }
    switch type {
    case .trend:
      // 1. 지금은 일차적으로 모든 경우에 대해서 토탈, 소팅으로만 했는데 이제 cell별로 분류해서 카테고리가 계절인지, 지역탐방인지 등등 파악해야해서
      // 2. postview의 footer에서 라인 과 간격을 10으로 수정했다는데 ,,, 뭔지모르겠어서 다시 확인해봐야해
      coordinator?.gotoTravelTrendBottomSheetPage()
    case .detailCategory(let themeType):
      coordinator?.gotoTravelThemeBottomSheetPage(sortingType: themeType)
    }
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
      coordinator?.gotoPostSearchPage()
    case .goToNotification:
      // transitionTODO: - Goto notifiation with naivgationController
      notificationBarItem.updateNotificationRedIcon(.none)
    case .gotoReviewWrite:
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          self.reviewWriteButton.backgroundColor = .yg.primary
        }, completion: { _ in
          self.coordinator?.gotoReviewWritePage()
        })
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .none:
      break
    }
  }
}

extension FeedViewController: TravelThemeBottomSheetDelegate {
  func travelThemeBottomSheetViewController(
    _ viewController: TravelThemeBottomSheetViewController,
    didSelectTitle title: String?
  ) {
    guard let title else {
      // 그냥 꺽쇠만 원래대로
      return
    }
    // TODO: - 서버에서 데이터 받은 후 특정 cell reload
    // 소분류 let type = viewController.travelThemeType.rawValue
    // 특정 상세 카테고리 title
  }
}

// MARK: - LayoutSupport
extension FeedViewController: LayoutSupport {
  func addSubviews() {
    _=[
      categoryPageView,
      reviewWriteButton
    ].map {
      view.addSubview($0)
    }
  }

  func setConstraints() {
    _=[
      categoryPageViewConstraint,
      reviewWriteButtonConstraint
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupprot helpers
private extension FeedViewController {
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
  
  var reviewWriteButtonConstraint: [NSLayoutConstraint] {
    typealias Const = Constant.ReviewWriteButton
    typealias Spacing = Const.Spacing
    return [
      reviewWriteButton.widthAnchor.constraint(
        equalToConstant: Const.size.width),
      reviewWriteButton.heightAnchor.constraint(
        equalToConstant: Const.size.height),
      reviewWriteButton.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -Spacing.trailing),
      reviewWriteButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -Spacing.bottom)]
  }
}
