//
//  UIButton+Combine.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/01.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public extension UIButton {
  var tap: AnyPublisher<Void, Never> {
    publihser(for: .touchUpInside)
      .map { _ in }
      .eraseToAnyPublisher()
  }
}
