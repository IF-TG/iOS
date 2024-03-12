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
    guard let reviewWritingVC = presenter?.viewControllers.last as? ReviewWritingViewController else { return }
    
    let vc = PhotoViewController()
    vc.imageCompletionHandler = { images in
      reviewWritingVC.setImageView(to: images)
    }
    presenter?.delegate = vc
    // TODO: - viewModel 추가하기
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
}