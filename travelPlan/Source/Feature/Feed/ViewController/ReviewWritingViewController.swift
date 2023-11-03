//
//  ReviewWritingViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 11/3/23.
//

import UIKit
import SnapKit

final class ReviewWritingViewController: UIViewController {
  // MARK: - Properties
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupStyles()
  }
}

// MARK: - Private Helpers
extension ReviewWritingViewController {
  private func setupStyles() {
    view.backgroundColor = .white
  }
}

// MARK: - LayoutSupport
extension ReviewWritingViewController: LayoutSupport {
  func addSubviews() {
    
  }
  
  func setConstraints() {
    
  }
}
