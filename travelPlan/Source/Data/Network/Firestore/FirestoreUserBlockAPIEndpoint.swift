//
//  FirestoreUserBlockAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/18/24.
//

import Foundation

struct FirestoreUserBlockAPIEndpoint {
  private init() {}
  
  static func makeUserBlockEndpoint(
    ownerId: UserIdentifier,
    willBlockedUserId blockedUserId: UserIdentifier
  ) -> FirestoreEndpoint<String> {
    return FirestoreEndpoint(
      method: .save(String(blockedUserId)),
      requestType: .users(.blockUser(ownerId)))
  }
  
  static func makeBlockedUserUnblockEndpoint(
    ownerId: UserIdentifier,
    blockedUserId: UserIdentifier
  ) -> FirestoreEndpoint<String> {
    return FirestoreEndpoint(
      method: .delete,
      requestType: .users(.unblockUser(ownerId, blockedUserId)))
  }
  
  static func makeBlockedUsersFetchEndpoint(
    ownerId: UserIdentifier
  ) -> FirestoreEndpoint<[String]> {
    return FirestoreEndpoint(
      method: .retrieveDocumentIdList,
      requestType: .users(.fetchBlockedUsers(ownerId)))
  }
}
