//
//  FirestoreRequestType.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import FirebaseFirestore
import SHFirestoreService

@frozen enum FirestoreRequestType: FirestoreAccessible {
  case users(UsersRequest)
  case blockedUsers
  case posts(Posts)
  case postComments
  
  private var collectionPath: String {
    switch self {
    case .users:
      "users"
    case .blockedUsers:
      "blockedUsers"
    case .posts(let posts):
      posts.collectionPath
    case .postComments:
      "postComments"
    }
  }
  
  var collectionRef: CollectionReference {
    return Firestore.firestore().collection(self.collectionPath)
  }
  
  var documentRef: DocumentReference? {
    switch self {
    case .users(let usersRequest):
      guard let documentPath = usersRequest.documentpath else { return nil }
      return collectionRef.document(documentPath)
    case .blockedUsers:
      return nil
    case .posts(let posts):
      guard let documentpath = posts.documentpath else { return nil }
      return collectionRef.document(documentpath)
    case .postComments:
      return nil
    }
  }
}

// MARK: - FirestoreRequest + UsersRequest
extension FirestoreRequestType {
  // TODO: - 관련 documentId associated Type으로 부여해야합니다.
  @frozen enum UsersRequest {
    typealias UID = String
    
    //    case updateProfile
    //    case saveProfile
    //    case deleteProfile
    //    case fetchProfile
    //
    //    case checkIfNameDuplicate
    //    case updateName
    
    case saveOwnerInfo(UID)
    case fetchAllUsers
    
    var documentpath: String? {
      switch self {
      case .saveOwnerInfo(let uID):
        return uID
      case .fetchAllUsers:
        return nil
      }
    }
  }
  
  // TODO: - 관련 documentId associated Type으로 부여해야합니다.
  @frozen enum UserBlockRequest {
    case block
    case fetchBlockedUsers
  }
}

extension FirestoreRequestType {
  @frozen enum Posts {
    case save
    
    private var rootPath: String {
      "posts"
    }
    
    var documentpath: String? {
      switch self {
      case .save:
        return nil
      }
    }
    
    var collectionPath: String {
      switch self {
      case .save:
        return rootPath
      }
    }
  }
}
