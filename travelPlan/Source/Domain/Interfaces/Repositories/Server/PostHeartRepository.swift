//
//  PostHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation
import Combine

protocol PostHeartRepository {
  func fetchHeartUsers(_ postId: String) -> AnyPublisher<[String], Error>
  func heartPost(_ postId: String, userId: String) -> AnyPublisher<Void, Error>
  func hatePost(_ postId: String, userId: String) -> AnyPublisher<Void, Error>
  func togglePostHearts(_ postId: String, willHeartPost: Bool) -> AnyPublisher<Void, Error>
}
