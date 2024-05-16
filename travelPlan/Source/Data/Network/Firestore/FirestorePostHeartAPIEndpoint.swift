//
//  FirestorePostHeartAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation

struct FirestorePostHeartAPIEndpoint {
  typealias UserIdentifier = String
  
  static func makeFetchPostHeartsEndpoint(
    _ postId: String
  ) -> FirestoreEndpoint<PostHeartsRespoonseDTO> {
    return .init(
      method: .get,
      requestType: .posts(.fetchPostHearts(postId)))
  }
  
  static func makeHeartPostEndpoint(
    postId: String,
    userId: String
  ) -> FirestoreEndpoint<String> {
    return .init(
      method: .save(postId),
      requestType: .users(.heartPost(userId)))
  }
  
  static func makeHatePostEndpoint(
    postId: String,
    userId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .delete,
      requestType: .users(.hatePost(userId, postId)))
  }
  
  static func makeTogglePostHeartsEndpoint(
    postId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .update,
      requestType: .posts(.togglePostHearts(postId)))
  }
  
  static func makeOwnerHeartPostIdentifiersFetchEndpoint(
    userId: String
  ) -> FirestoreEndpoint<UserIdentifier> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .users(.fetchHeartPostIdentifiers(userId)))
  }
  
  static func makeOwnerHasHeartSpecificPostEndpoint(
    postId: String,
    userId: String
  ) -> FirestoreEndpoint<Bool> {
    return FirestoreEndpoint(requestType: .users(.hasOwnerHeartPost(userId, postId)))
  }
}
