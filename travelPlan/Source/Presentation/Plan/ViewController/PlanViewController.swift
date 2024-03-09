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
    let scrollView = UIScrollView(frame: .zero)
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    let imageView = UIImageView(image: UIImage(named: "tempPlanPage"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.heightAnchor.constraint(equalToConstant: 1123).isActive = true
    scrollView.addSubview(imageView)
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -47-44),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)])
  }
  
  deinit {
    coordinator?.finish()
  }
}
