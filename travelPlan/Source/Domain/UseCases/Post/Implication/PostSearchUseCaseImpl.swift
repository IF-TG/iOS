//
//  PostSearchUseCaseImpl.swift
//  travelPlan
//
//  Created by 양승현 on 5/17/24.
//

import Combine
import Foundation

final class PostSearchUseCaseImpl {
  // MARK: - Dependencies
  
  // MARK: - Properties
  
  // MARK: - Lifecycle
}

// MARK: - PostSearchUseCase
extension PostSearchUseCaseImpl: PostSearchUseCase {
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    fatalError("검색업체 algorlia 사용해서 검색 기능 구현")
  }
}
