//
//  PostHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/3/24.
//

import Foundation
import Combine

protocol PostHeartUseCase {
  func fetchHeartUsers(
    _ postId: String
  ) -> AnyPublisher<[String], Error>
  
  func fetchPostHearts(
    _ postId: String
  ) -> AnyPublisher<Int, Error>
  
  func heartPost(
    _ postId: String
  ) -> AnyPublisher<Int, Error>
  
  func hatePost(
    _ postId: String
  ) -> AnyPublisher<Int, Error>
}
