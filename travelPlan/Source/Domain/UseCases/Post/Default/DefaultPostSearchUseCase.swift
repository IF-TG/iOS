//
//  DefaultPostSearchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class DefaultPostSearchUseCase: PostSearchUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    return postRepository.searchPosts(
      keyword: keyword,
      page: page,
      perPage: perPage,
      isTitle: isTitle,
      isContent: isContent)
  }
}
