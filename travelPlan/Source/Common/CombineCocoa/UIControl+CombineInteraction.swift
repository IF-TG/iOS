//
//  UIControl+CombineInteraction.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/01.
//

import UIKit
import Combine

// MARK: - CombineInteraction
extension UIControl {
  
  // MARK: - InteractionSubscription
  class InteractionSubscription<S: Subscriber>: Subscription
  where S.Input == UIControl
  {
    private var subscriber: S?
    private let control: UIControl
    private let event: UIControl.Event
    
    init(
      subscriber: S,
      control: UIControl,
      event: UIControl.Event
    ) {
      self.subscriber = subscriber
      self.control = control
      self.event = event
      
      self.control.addTarget(self, action: #selector(handleEvent), for: event)
    }
    
    @objc func handleEvent(_ sender: UIControl) {
      _=self.subscriber?.receive(control)
    }
    
    // MARK: - Subscription
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
      subscriber = nil
      control.removeTarget(self, action: #selector(handleEvent), for: event)
    }
  }
  
  // MARK: - InteractionPublihser
  struct InteractionPublihser: Publisher {
    typealias Output = UIControl
    typealias Failure = Never
    
    private let control: UIControl
    private let event: UIControl.Event
    
    init(control: UIControl, event: UIControl.Event) {
      self.control = control
      self.event = event
    }
    
    // MARK: - Publihser
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = InteractionSubscription(
        subscriber: subscriber,
        control: control,
        event: event)
      
      subscriber.receive(subscription: subscription)
    }
  }
}
