//
//  PostHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation
import Combine

protocol PostHeartRepository {
  /// 포스트 좋아요 한 사용자들의 ID를 반환합니다.
  func fetchHeartUsers(_ postId: String) -> AnyPublisher<[String], Error>
  
  /// 포스트 좋아요 한 개수를 반환합니다.
  func fetchPostHearts(_ postId: String) -> AnyPublisher<Int, Error>
  
  /// 사용자가 포스트를 하트 표시 합니다.
  func heartPost(_ postId: String, userId: String) -> AnyPublisher<Void, Error>
  
  /// 사용자가 포스트 하트표시 하지 않습니다.
  func hatePost(_ postId: String, userId: String) -> AnyPublisher<Void, Error>
  
  /// DB내부에서 serial하게 포스트 좋아요 개수를 증가 또는 감소 시킵니다.
  func togglePostHearts(_ postId: String, willHeartPost: Bool) -> AnyPublisher<Void, Error>
}
