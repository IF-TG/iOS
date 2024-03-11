//
//  FavoriteLocationViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit
import Combine

final class FavoriteLocationViewController: EmptyStateBasedContentViewController {
  private let tempLocationView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  init() {
    super.init(contentView: tempLocationView, emptyState: .emptyTravelLocation)
    hasItem.send(false)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - FavoriteDetailMenuViewConfigurable 
extension FavoriteLocationViewController: FavoriteDetailMenuViewConfigurable {
  var numberOfItems: Int {
    0
  }
}
