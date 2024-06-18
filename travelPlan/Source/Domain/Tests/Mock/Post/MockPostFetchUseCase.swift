//
//  MockPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class MockPostFetchUseCase: PostFetchUseCase {
  func fetchPost(with postId: PostIdentifier) -> AnyPublisher<Post, any Error> {
    let mockPost = mockPostsGenerator.mockPostPage.posts[2]
    return Just(Post(
      liked: true,
      detail: .init(postID: 1, title: "공유하기에 의해 받아졌습니다.",
                    content: mockPost.detail.content,
                    likes: 0, comments: 0, location: .init(x: 0, y: 0),
                    createAt: Date(), tripDate: .init(startDate: .init(), endDate: .init())),
      author: .init(profileImageData: nil, nickname: "여행자", authorId: 111),
      highResolveImages: mockPost.highResolveImages, 
      category: .init(themes: [], regions: [], seasons: [], partners: [.lover]))
    ).setAnyErrorAndEraseToAnyPublisher()
  }
  
  var mockPostsGenerator = MockPostsGeneratorForPaging()
  
  func fetchFilteredPosts(
    with page: PostFetchRequestValue
  ) -> AnyPublisher<PostsPage, any Error> {
    if mockPostsGenerator.index > mockPostsGenerator.totalPage {
      return Fail(error: PaginationError.noMorePage).eraseToAnyPublisher()
    }
    let responseData = {
      let nextPosts = (mockPostsGenerator.index..<mockPostsGenerator.index+5)
        .map { mockPostsGenerator.mockPostPage.posts[$0] }
      let nextThumbnails = (mockPostsGenerator.index..<mockPostsGenerator.index+5)
        .map { mockPostsGenerator.mockPostPage.thumbnails[$0] }
      return PostsPage(posts: nextPosts, thumbnails: nextThumbnails)
    }()
    mockPostsGenerator.index+=5
    return Just(responseData)
      .delay(for: .seconds(0.18), scheduler: DispatchQueue.global(qos: .background))
      .setAnyErrorAndEraseToAnyPublisher()
  }
}
