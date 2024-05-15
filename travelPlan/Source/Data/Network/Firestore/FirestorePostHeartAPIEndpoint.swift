//
//  FirestorePostHeartAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation

struct FirestorePostHeartAPIEndpoint {
  // TODO: - 이거 필드에서 얻어오는거로 바꿔야함 -> 사용하는 레포에서도 함수인가.. 로직 바꿔야함?
  static func makeFetchPostHeartsEndpoint(
    _ postId: String
  ) -> FirestoreEndpoint<PostHeartsRespoonseDTO> {
    return .init(
      method: .retrieveNumberOfDocuments,
      requestType: .posts(.fetchPostHearts(postId)))
  }
  
  static func makeHeartPostEndpoint(
    postId: String
  ) -> FirestoreEndpoint<String> {
    return .init(
      method: .save(postId),
      requestType: .users(.heartPost))
  }
  
  static func makeHatePostEndpoint(
    postId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .delete,
      requestType: .users(.hatePost(postId)))
  }
  
  static func makeTogglePostHeartsEndpoint(
    postId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .update,
      requestType: .posts(.togglePostHearts(postId)))
  }
}
