//
//  FavoriteLocationViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit
import Combine

// TODO: - 로케이션 뷰 구체적 지정되면 해당 뷰로 변환해야 합니다.
fileprivate class TempFavoriteLocationView: UIView & EmptyStateBasedContentViewCheckable {
  var hasItem: CurrentValueSubject<Bool, Never> = .init(true)
  
  var isShowingFirstAnimation: Bool = true
}

final class FavoriteLocationViewController: EmptyStateBasedContentViewController {
  private let tempLocationView = TempFavoriteLocationView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .orange
  }
  
  init() {
    super.init(contentView: tempLocationView, emptyState: .emptyTravelLocation)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - FavoriteDetailMenuViewConfigurable 
extension FavoriteLocationViewController: FavoriteDetailMenuViewConfigurable {
  var numberOfItems: Int {
    17
  }
}
