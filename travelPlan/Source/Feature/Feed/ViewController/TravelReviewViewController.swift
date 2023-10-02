//
//  TravelReviewViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/2/23.
//

import UIKit

final class TravelReviewViewController: UIViewController {
  
  // MARK: - Lifecycle
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    temp()
  }
  
  // MARK: - Private helper
  private func configureUI() {
    view.backgroundColor = .white
    setupBackBarButtonItem()
  }
  private func temp() {
    _=UIImageView(image: UIImage(named: "tempTravelReviewPage")).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentMode = .scaleAspectFit
      view.addSubview($0)
      NSLayoutConstraint.activate([
        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        $0.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
  }
}
