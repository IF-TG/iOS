//
//  UIGestureRecognizer.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit.UIGestureRecognizer
import Combine

// MARK: - Nested
public extension UIGestureRecognizer {
  // MARK: - UIGestureRecognizer's Subscription
  class Subscription<Gesture, Subscriber>: Combine.Subscription
  where Gesture: UIGestureRecognizer,
        Subscriber: Combine.Subscriber,
        Subscriber.Input == Gesture,
        Subscriber.Failure == Never {
    // MARK: - Properties
    private var subscriber: Subscriber?
    private let gestureRecognizer: Gesture
    private let view: UIView
    
    // MARK: - Lifecycle
    init(subscriber: Subscriber?, gestureRecognizer: Gesture, view: UIView) {
      self.subscriber = subscriber
      self.gestureRecognizer = gestureRecognizer
      self.view = view
      gestureRecognizer.addTarget(self, action: #selector(handleGesture))
      view.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Helpers
    public func request(_ demand: Subscribers.Demand) { }
    
    public func cancel() {
      view.removeGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Action
    @objc func handleGesture(_ gesture: UIGestureRecognizer) {
      _=subscriber?.receive(gestureRecognizer)
    }
  }
  
  // MARK: - UIGestureRecognizer's publisher
  struct Publisher<Gesture>: Combine.Publisher where Gesture: UIGestureRecognizer {
    // MARK: - Cosntant
    public typealias Output = Gesture
    public typealias Failure = Never
    
    // MARK: - Properteis
    private let gestureRecognizer: Gesture
    private let view: UIView
    
    // MARK: - Lifecycle
    init(gestureRecognizer: Gesture, view: UIView) {
      self.gestureRecognizer = gestureRecognizer
      self.view = view
    }
    
    // MARK: - Helpers
    public func receive<S>(subscriber: S) 
    where S: Subscriber,
            Never == S.Failure,
            Gesture == S.Input {
      let subscription = Subscription(subscriber: subscriber, gestureRecognizer: gestureRecognizer, view: view)
      
      subscriber.receive(subscription: subscription)
    }
  }
  
}
