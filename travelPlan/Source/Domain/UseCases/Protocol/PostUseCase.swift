//
//  PostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Combine
import Foundation

enum PostUseCaseError: LocalizedError {
  case noMorePage
  
  var errorDescription: String? {
    return switch self {
    case .noMorePage:
      "더 이상의 페이지가 존재하지 않습니다."
    }
  }
}

struct PostFetchRequestValue {
  let page: Int32
  let perPage: Int32
  let category: PostCategory
}

protocol PostUseCase {  
  func fetchPosts(with page: PostFetchRequestValue) -> AnyPublisher<PostsPage, Error>
}
