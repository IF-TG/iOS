//
//  BaseFavoriteContentViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

class BaseFavoriteContentViewController: UIViewController {
  // MARK: - Properties
  private let contentView: UIView
  
  
  // MARK: - Lifecycle
  init(contentView: UIView) {
    self.contentView = contentView
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    contentView = UIView(frame: .zero)
    super.init(coder: coder)
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Helpers
extension BaseFavoriteContentViewController {
  
}

// MARK: - Private Helpers
private extension BaseFavoriteContentViewController {
  func configureUI() {
    view.backgroundColor = .white
  }
}

// MARK: - Actions

// MARK: - LayoutSupport

// MARK: - LayoutSupport Constraints

