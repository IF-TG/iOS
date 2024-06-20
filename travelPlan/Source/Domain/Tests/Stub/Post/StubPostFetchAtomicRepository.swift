//
//  StubPostFetchAtomicRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
@testable import travelPlan

final class StubPostFetchAtomicRepository: PostFetchAtomicRepository {
  private let stubPostDetail: Post.Detail<[Post.PostContent]> = .init(
    postID: 11, title: "temp", content: [.init(sort: 0, text: "temp")],
    likes: 0, comments: 0, location: .init(x: 0, y: 0), createAt: Date(),
    tripDate: .init(startDate: Date(), endDate: Date()))
  
  private let category = Post.Category(themes: [], regions: [], seasons: [], partners: [.friend])
  
  private var stubAtomicPost: [AtomicPost] {
    return [
      AtomicPost(authorId: 1, detail: stubPostDetail, category: category,
                 highResolveImages: [.init(imageData: Data(), sort: 1)]),
      AtomicPost(authorId: 2, detail: stubPostDetail, category: category,
                 highResolveImages: [.init(imageData: Data(), sort: 1)])]
  }
  
  func fetchFilteredPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<[AtomicPost], any Error> {
    return makeAtomicPostsPublisher()
  }
  
  func fetchOwnerLikedPosts(
    page: Int32,
    perPage: Int32,
    likedPostIdList: [PostIdentifier]
  ) -> AnyPublisher<[AtomicPost], any Error> {
    return makeAtomicPostsPublisher()
  }
  
  func fetchOwnerWrotePosts(
    isFirstPage: Bool,
    perPage: Int32
  ) -> AnyPublisher<[AtomicPost], any Error> {
    return makeAtomicPostsPublisher()
  }
  
  private func makeAtomicPostsPublisher() -> AnyPublisher<[AtomicPost], any Error> {
    return Just(stubAtomicPost).setAnyErrorAndEraseToAnyPublisher()
  }
}
