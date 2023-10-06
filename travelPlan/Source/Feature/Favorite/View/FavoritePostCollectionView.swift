//
//  FavoritePostCollectionView.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit
import Combine

final class FavoritePostCollectionView: PostCollectionView, EmptyStateBasedContentViewCheckable {
  var hasItem: CurrentValueSubject<Bool, Never> = .init(false)
  
  var isShowingFirstAnimation: Bool = true
  
  init() {
    super.init(frame: .zero)
    bounces = false
    showsVerticalScrollIndicator = false
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
