//
//  UserBlockUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Combine

protocol UserBlockUseCase {
  func blockUser(with userId: Int64) -> AnyPublisher<BlockedUserIdentifyEntity, Error>
}
