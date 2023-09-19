//
//  SearchDetailCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/16.
//

import UIKit
import SHCoordinator

final class SearchDetailCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController
  
  // weakTODO: - viewController를 weak로 설정해야 합니다.
  var viewController: UIViewController!
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController, type: SearchSectionType) {
    self.presenter = presenter
    
    let searchDetailVC = SearchDetailViewController(type: type)
    searchDetailVC.coordinator = self
    viewController = searchDetailVC
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Start
  func start() {
//    guard let viewController = self.viewController else { return }
    presenter.pushViewController(viewController, animated: true)
  }
}
