//
//  FirestorePostHeartAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation

struct FirestorePostHeartAPIEndpoint {
  static func makeFetchPostHeartsEndpoint(
    _ postId: PostIdentifier
  ) -> FirestoreEndpoint<PostHeartsRespoonseDTO> {
    return .init(
      method: .get,
      requestType: .posts(.fetchPostHearts(postId)))
  }
  
  static func makeHeartPostEndpoint(
    postId: PostIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<String> {
    return .init(
      method: .save(String(postId)),
      requestType: .users(.heartPost(userId)))
  }
  
  static func makeHatePostEndpoint(
    postId: PostIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .delete,
      requestType: .users(.hatePost(userId, postId)))
  }
  
  static func makeTogglePostHeartsEndpoint(
    postId: PostIdentifier
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .update,
      requestType: .posts(.togglePostHearts(postId)))
  }
  
  static func makeOwnerHeartPostIdentifiersFetchEndpoint(
    userId: UserIdentifier
  ) -> FirestoreEndpoint<[String]> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .users(.fetchHeartPostIdentifiers(userId)))
  }
  
  static func makeOwnerHasHeartSpecificPostEndpoint(
    postId: PostIdentifier,
    userId: UserIdentifier
  ) -> FirestoreEndpoint<Bool> {
    return FirestoreEndpoint(requestType: .users(.hasOwnerHeartPost(userId, postId)))
  }
}
