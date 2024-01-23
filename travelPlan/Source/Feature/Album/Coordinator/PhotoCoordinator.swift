//
//  PhotoCoordinator.swift
//  travelPlan
//
//  Created by SeokHyun on 1/14/24.
//

import UIKit
import SHCoordinator

final class PhotoCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  // MARK: - LifeCycle
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  // MARK: - Helpers
  func start() {
    let vc = PhotoViewController()
    presenter?.delegate = vc
    // TODO: - viewModel 추가하기
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
}
