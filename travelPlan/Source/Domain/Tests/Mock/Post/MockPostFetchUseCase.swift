//
//  MockPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class MockPostFetchUseCase: PostFetchUseCase {
  func fetchPost(with postId: Int32) -> AnyPublisher<Post, any Error> {
    return Just(Post(
      liked: true,
      detail: .init(postID: "1", title: "공유하기에 의해 받아졌습니다.",
                    content: [.init(sort: 1, text: "공유하기에 의해 받아진 컨텐츠")],
                    likes: 0, comments: 0, location: .init(x: 0, y: 0),
                    createAt: Date(), tripDate: .init(startDate: .init(), endDate: .init())),
      author: .init(profileImageData: nil, nickname: "여행자"),
      highResolveImages: [], category: .init(themes: [], regions: [], seasons: [], partners: [.lover]))
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
