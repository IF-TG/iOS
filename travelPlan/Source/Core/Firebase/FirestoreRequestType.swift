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
  case users(UsersCollection)
  case posts
  
  private var collectionPath: String {
    switch self {
    case .users(let users):
      users.collectionPath
    case .posts:
      "posts"
    }
  }
  
  var collectionRef: CollectionReference {
    if documentRef == nil {
      Firestore.firestore().collection(self.collectionPath)
    }
    return Firestore.firestore().collection(self.collectionPath)
  }
  
  var documentRef: DocumentReference? {
    switch self {
    case .users(let usersRequest):
      guard let documentPath = usersRequest.documentPath else { return nil }
      return collectionRef.document(documentPath)
    case .posts:
      return nil
    }
  }
}

// MARK: - FirestoreRequest + UsersRequest
extension FirestoreRequestType {
  @frozen enum UsersCollection {
    /// 모든 유저 문서 받아옴
    case fetchAllUsers
    case userDocument(UserDocument)
    
    var rootPath: String {
      "users"
    }
    
    var documentPath: String? {
      switch self {
      case .fetchAllUsers:
        return nil
      case .userDocument(let user):
        if let userDocuemntPath = user.docuemntPath {
          return "\(rootPath)\(userDocuemntPath)"
        }
        return nil
      }
    }
    
    var collectionPath: String {
      switch self {
      case .fetchAllUsers:
        return rootPath
        
      /// 사용자 도큐먼트에서는 하위 collection으로 접근하지 않는 경우 문서에 접근하는 것임으로 rootPath반환
      case .userDocument(let userDocument):
        if let childCollectionPath = userDocument.childCollectionPath {
          return "\(rootPath)\(childCollectionPath)"
        }
        return rootPath
      }
    }
  }
  
  @frozen enum UserDocument {
    case user(String)
    //    case updateProfile
    //    case updateName
    //    case updateProfile
    //    case saveProfileImage
    //    case deleteProfile
    //    case fetchProfileImage
    //
    //    case checkIfNameDuplicate
    //    case updateName
    //    case fetchAllUsers
    //    case deleteUser(String)
    case blockedUsersCollection(String, BlockedUserCollection)
    
    var docuemntPath: String? {
      switch self {
      case .user(let UID):
        return UID
      case .blockedUsersCollection(let UID, let requestType):
        if let subDocumentPath = requestType.documentPath {
          return "/\(UID)\(subDocumentPath)"
        }
        return nil
      }
    }
    
    var childCollectionPath: String? {
      switch self {
      case .user(let UID):
        return nil
      case .blockedUsersCollection(let uid, let blockedUserCollection):
        return "/\(uid)\(blockedUserCollection.collectionPath)"
      }
    }
  }
  
  @frozen enum BlockedUserCollection {
    case blockUser
    case fetchBlockedUsers
    
    var collectionPath: String {
      "/blocked-users"
    }
    
    var documentPath: String? {
      switch self {
      case .blockUser:
        return nil
      case .fetchBlockedUsers:
        return nil
      }
    }
  }
}
