//
//  FirestorePostHeartAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation

struct FirestorePostHeartAPIEndpoint {
  static func makeFetchHeartUsersEndpoint(_ postId: String)
  -> FirestoreEndpoint<[String]> {
    return .init(
      method: .retrieveDocumentIdList,
      requestType: .posts(.fetchHeartUsers(postId)))
  }
  
  static func makeHeartPostEndpoint(
    postId: String,
    userId: String
  ) -> FirestoreEndpoint<String> {
    return .init(
      method: .save(userId),
      requestType: .posts(.heartPost(postId)))
  }
}
