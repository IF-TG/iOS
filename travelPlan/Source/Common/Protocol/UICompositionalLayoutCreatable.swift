//
//  UICompositionalLayoutCreatable.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/25.
//

import UIKit.UICollectionViewCompositionalLayout

/// UICollectionViewCompositionalLayout을 생성하는 객체는 해당 프로토콜을 준수합니다.
protocol CompositionalLayoutCreatable {
  func makeLayout() -> UICollectionViewCompositionalLayout
}
