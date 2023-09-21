//
//  UISwitch+Combine.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/01.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UISwitch {
  /// A publihser emitting any text changes
  var changed: AnyPublisher<Bool, Never> {
    publihser(for: .editingChanged)
      .compactMap { ($0 as? UISwitch)?.isOn }
      .eraseToAnyPublisher()
  }
}
