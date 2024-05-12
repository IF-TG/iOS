//
//  Combine+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Foundation
import Combine

extension Publisher {
  func subscribeAndReceive(
    on queue: DispatchQueue
  ) -> Publishers.ReceiveOn<Publishers.SubscribeOn<Self, DispatchQueue>, DispatchQueue> {
    return self.subscribe(on: queue).receive(on: queue)
  }
}
