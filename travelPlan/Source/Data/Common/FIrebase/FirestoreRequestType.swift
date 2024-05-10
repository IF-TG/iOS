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
  case posts(PostsCollection)
  
  private var collectionPath: String {
    switch self {
    case .users(let users):
      users.collectionPath
    case .posts(let posts):
      posts.collectionPath
    }
  }
  
  var collectionRef: CollectionReference {
    Firestore.firestore().collection(collectionPath)
  }
  
  var documentRef: DocumentReference? {
    switch self {
    case .users(let usersRequest):
      guard let documentPath = usersRequest.documentPath else { return nil }
      return collectionRef.document(documentPath)
    case .posts(let posts):
      guard let documentPath = posts.documentpath else { return nil }
      return collectionRef.document(documentPath)
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
          return userDocuemntPath
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
    case fetchUserProfile(String)
    case saveUserProfile
    //    case updateProfileImage
    //    case updateName
    //    case updateProfileImage
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
      case .fetchUserProfile(let UID):
        return UID
      case .saveUserProfile:
        return nil
      case .blockedUsersCollection(_, let requestType):
        if let subDocumentPath = requestType.documentPath {
          return subDocumentPath
        }
        return nil
      }
    }
    
    var childCollectionPath: String? {
      switch self {
      case .fetchUserProfile:
        return nil
      case .saveUserProfile:
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

// MARK: - Posts
extension FirestoreRequestType {
  @frozen enum PostsCollection {
    typealias PostId = String
    typealias UserId = String
    typealias CommentId = String
    typealias NestedCommentId = String
    
    case save
    case update(postId: String)
    case fetch
    
    // MARK: - PostHearts
    case fetchHeartUsers(PostId)
    case fetchPostHearts(PostId)
    case heartPost(PostId)
    case hatePost(PostId, UserId)
    case togglePostHearts(PostId)
    
    // MARK: - PostCommentHearts
    case fetchCommentHeartUsers(PostId, CommentId)
    case heartComment(PostId, CommentId)
    case hateComment(PostId, CommentId, UserId)
    case updateCommentHearts(PostId, CommentId)
    case fetchCommentHearts(PostId, CommentId)
    
    // MARK: - PostComments
    case saveComment(PostId, CommentId)
    case updateComment(PostId, CommentId)
    /// 이 경우는 isDelete 필드 true로 변경
    case deleteCommentWhenNestedCommentExists(PostId, CommentId)
    /// 그냥 삭제
    case deleteComment(PostId, CommentId)
    case fetchComments(PostId)
    
    // MARK: - PostNestedComments
    case saveNestedComment(PostId, CommentId)
    case deleteNestedComment(PostId, CommentId, NestedCommentId)
    case updateNestedComment(PostId, CommentId, NestedCommentId)
    case fetchNestedComments(PostId, CommentId)
    case deleteAllNestedComments(PostId, CommentId)

    // MARK: - PostNestedCommentHearts
    case fetchNestedCommentHeartUsers(PostId, CommentId, NestedCommentId)
    case heartNestedComment(PostId, CommentId, NestedCommentId)
    case hateNestedComment(PostId, CommentId, NestedCommentId, UserId)
    case updateNestedCommentHearts(PostId, CommentId, NestedCommentId)
    case fetchNestedCommentHearts(PostId, CommentId, NestedCommentId)
    
    private var rootPath: String {
      "posts"
    }
    
    private var comments: String {
      "comments"
    }
    
    private var postHearts: String {
      "post-hearts"
    }
    
    private var commentHearts: String {
      "comment-hearts"
    }
    
    private var nestedCommentHearts: String {
      "comment-hearts"
    }
    
    private var nestedComments: String {
      "nested-comments"
    }
    
    private func commentPath(from postId: String) -> String {
      return "\(rootPath)/\(postId)/\(comments)"
    }
    
    var documentpath: String? {
      switch self {
      case .save:
        return nil
      case .update(let postId):
        return postId
      case .fetch:
        return nil
      case .fetchHeartUsers:
        return nil
      case .heartPost:
        return nil
      case .hatePost(_, let userId):
        return userId
      case .togglePostHearts(let postId):
        return postId
      case .fetchPostHearts(let postId):
        return postId
      case .fetchCommentHeartUsers:
        return nil
      case .heartComment:
        return nil
      case .hateComment(_, _, let userId):
        return userId
      case .updateCommentHearts(_, let commentId):
        return commentId
      case .fetchCommentHearts(_, let commentId):
        return commentId
      case .saveComment:
        return nil
      case .updateComment(_, let commentId):
        return commentId
      case .deleteCommentWhenNestedCommentExists(_, let commentId):
        return commentId
      case .deleteComment(_, let commentId):
        return commentId
      case .fetchComments:
        return nil
      case .saveNestedComment:
        return nil
      case .deleteNestedComment(_, _, let nestedCommentId):
        return nestedCommentId
      case .updateNestedComment(_, _, let nestedCommentId):
        return nestedCommentId
      case .fetchNestedComments:
        return nil
      case .deleteAllNestedComments:
        return nil
      case .fetchNestedCommentHeartUsers:
        return nil
      case .heartNestedComment:
        return nil
      case .hateNestedComment(_, _, _, let userId):
        return userId
      case .updateNestedCommentHearts(_, _, let nestedCommentId):
        return nestedCommentId
      case .fetchNestedCommentHearts(_, _, let nestedCommentId):
        return nestedCommentId
      }
    }
    
    var collectionPath: String {
      switch self {
      case .save:
        return rootPath
      case .update:
        return rootPath
      case .fetch:
        return rootPath
      case .fetchHeartUsers(let postId):
        return "\(rootPath)/\(postId)/\(postHearts)"
      case .heartPost(let postId):
        return "\(rootPath)/\(postId)/\(postHearts)"
      case .hatePost(let postId, _):
        return "\(rootPath)/\(postId)/\(postHearts)"
      case .togglePostHearts:
        return rootPath
      case .fetchPostHearts:
        return rootPath
      case .fetchCommentHeartUsers(let postId, let commentId):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(commentHearts)"
      case .heartComment(let postId, let commentId):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(commentHearts)"
      case .hateComment(let postId, let commentId, _):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(commentHearts)"
      case .updateCommentHearts(let postId, _):
        return "\(rootPath)/\(postId)/\(comments)"
      case .fetchCommentHearts(let postId, _):
        return "\(rootPath)/\(postId)/\(comments)"
      case .saveComment(let postId, _):
        return "\(rootPath)/\(postId)/\(comments)"
      case .updateComment(let postId, _):
        return "\(rootPath)/\(postId)/\(comments)"
      case .deleteCommentWhenNestedCommentExists(let postId, _):
        return "\(rootPath)/\(postId)/\(comments)"
      case .deleteComment(let postId, _):
        return "\(rootPath)/\(postId)/\(comments)"
      case .fetchComments(let postId):
        return "\(rootPath)/\(postId)/\(comments)"
      case .saveNestedComment(let postId, let commentId):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(nestedComments)"
      case .deleteNestedComment(let postId, let commentId, _):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(nestedComments)"
      case .updateNestedComment(let postId, let commentId, _):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(nestedComments)"
      case .fetchNestedComments(let postId, let commentId):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(nestedComments)"
      case .deleteAllNestedComments(let postId, let commentId):
        return "\(rootPath)/\(postId)/\(comments)/\(commentId)/\(nestedComments)"
        return "\(commentPath(from: postId))/\(commentId)/\(nestedComments)"
      case .fetchNestedCommentHeartUsers(let postId, let commentId, let nestedCommentId):
        return "\(commentPath(from: postId))/\(commentId)/\(nestedComments)/\(nestedCommentId)/\(nestedCommentHearts)"
      case .heartNestedComment(let postId, let commentId, let nestedCommentId):
        return "\(commentPath(from: postId))/\(commentId)/\(nestedComments)/\(nestedCommentId)/\(nestedCommentHearts)"
      case .hateNestedComment(let postId, let commentId, let nestedCommentId, _):
        return "\(commentPath(from: postId))/\(commentId)/\(nestedComments)/\(nestedCommentId)/\(nestedCommentHearts)"
      case .updateNestedCommentHearts(let postId, let commentId, _):
        return "\(commentPath(from: postId))/\(commentId)/\(nestedComments)"
      case .fetchNestedCommentHearts(let postId, let commentId, _ ):
        return "\(commentPath(from: postId))/\(commentId)/\(nestedComments)"
      }
    }
  }
}
