//
//  UIView+WrapperPublisher.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIView {
  var tapGesture: AnyPublisher<Void, Never> {
    publisher(for: .tap)
      .map { _ in }
      .eraseToAnyPublisher()
  }
  
  var swipeGesture: AnyPublisher<UISwipeGestureRecognizer, Never> {
    publisher(for: .swipe)
      .compactMap { $0 as? UISwipeGestureRecognizer }
      .eraseToAnyPublisher()
  }
  
  var panGesture: AnyPublisher<UIPanGestureRecognizer, Never> {
    publisher(for: .pan)
      .compactMap { $0 as? UIPanGestureRecognizer }
      .eraseToAnyPublisher()
  }
  
  var edgeGesture: AnyPublisher<UIScreenEdgePanGestureRecognizer, Never> {
    publisher(for: .edge)
      .compactMap { $0 as? UIScreenEdgePanGestureRecognizer }
      .eraseToAnyPublisher()
  }
  
  var pinchGestrue: AnyPublisher<UIPinchGestureRecognizer, Never> {
    publisher(for: .pinch)
      .compactMap { $0 as? UIPinchGestureRecognizer }
      .eraseToAnyPublisher()
  }
  
  var longPressGesture: AnyPublisher<UILongPressGestureRecognizer, Never> {
    publisher(for: .longPress)
      .compactMap { $0 as? UILongPressGestureRecognizer }
      .eraseToAnyPublisher()
  }
}
