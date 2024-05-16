//
//  OwnerHeartPostIdentifierFetchRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

protocol OwnerHeartPostRepository {
  typealias PostIdentifier = String
  func fetchOwnerHeartPostIdentifiers() -> AnyPublisher<[PostIdentifier], any Error>
  func hasOwnerHeartPost(postId: PostIdentifier) -> AnyPublisher<Bool, any Error>
}
