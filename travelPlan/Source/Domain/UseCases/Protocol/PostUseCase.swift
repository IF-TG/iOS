//
//  PostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/6/24.
//

import Combine

struct PostCommentsReqeustValue {
  let page: Int32
  let perPage: Int32
  let postId: Int64
}

protocol PostUseCase {
  var postContainers: PassthroughSubject<[PostContainer], MainError> { get }
  
  func fetchPosts(with page: PostsPage)
  
  func fetchComments(
    with requestValue: PostCommentsReqeustValue
  ) -> AnyPublisher<PostCommentContainerEntity, Error>
}
