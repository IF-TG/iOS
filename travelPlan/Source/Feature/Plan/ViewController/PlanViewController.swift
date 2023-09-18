//
//  PlanViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class PlanViewController: UIViewController {
  // MARK: - Properties
  weak var coordinator: PlanCoordinatorDelegate?
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .cyan.withAlphaComponent(0.3)
    // Do any additional setup after loading the view.
  }
  
  deinit {
    coordinator?.finish()
  }
}
