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
  
  /// 포스트 하트, hate를 한 이후에 fetchPostHearts를 통해 현재 포스트 좋아요를 가저올 수있지만
  /// 하트 하나에 파베 접근이 너무 많이 사용될 수 있기에 현재 포스트 좋아요 개수는 가져오지 않도록 했습니다.
  func heartPost(
    _ postId: String
  ) -> AnyPublisher<Void, Error>
  
  func hatePost(
    _ postId: String
  ) -> AnyPublisher<Void, Error>
}
