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
}

// MARK: - Private helpers
extension TravelReviewViewController {
  private func configureUI() {
    view.backgroundColor = .white
//    setupBackBarButtonItem()
  }
  
  private func temp() {
    let scrollView = UIScrollView().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
      NSLayoutConstraint.activate([
        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    let deviceSize = UIScreen.main.bounds.size
    let rect = CGRect(x: 0, y: 0, width: deviceSize.width, height: deviceSize.height-44 - 20)
    _=UIImageView(frame: rect).set {
      $0.image = UIImage(named: "tempTravelReviewPage")
      $0.contentMode = .scaleAspectFit
      scrollView.addSubview($0)
      scrollView.contentSize = $0.bounds.size
    }
  }
}
