//
//  SubPathType.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation

enum RequestType {
  case none
  case login(LoginRequestType)
  case user(UserRequestType)
  case post(PostRequestType)
  case postComment(PostCommentRequestType)
  case postNestedComment(PostNestedCommentRequestType)
  
  var path: String {
    return switch self {
    case .none:
      ""
    case .post(let post):
      post.path
    case .postComment(let postComment):
      postComment.path
    case .postNestedComment(let nestedComment):
      nestedComment.path
    case .user(let userRequestType):
      userRequestType.path
    case .login(let loginRequestType):
      loginRequestType.path
    }
  }
}

// MARK: - Login request type
extension RequestType {
  @frozen enum LoginRequestType {
    case apple
    
    var path: String {
      switch self {
      case .apple:
        "apple/login"
      }
    }
  }
}

// MARK: - User relate Request type
extension RequestType {
  @frozen enum UserRequestType {
    case profile(UserProfile)
    case otherUserBlock(UserBlock)
    
    var path: String {
      switch self {
      case .profile(let userProfile):
        userProfile.path
      case .otherUserBlock(let userBlock):
        userBlock.path
      }
    }
    
    @frozen enum UserBlock {
      case userBlock
      case blockedUsersFetch
      
      var path: String {
        switch self {
        case .userBlock:
          return "blockUser"
        case .blockedUsersFetch:
          return "blockUser/list"
        }
      }
    }
    
    @frozen enum UserProfile {
      case update
      case save
      case delete
      case fetch
      /// 사용자 이름 중복 체크와 사용자 이름 업데이트 두 개의 로직에서 사용중
      case checkIfNameDuplicate
      
      var path: String {
        return switch self {
        case .update:
          "profile/upload"
        case .save:
          "profile/upload"
        case .delete:
          "profile"
        case .fetch:
          "profile/original"
        case .checkIfNameDuplicate:
          "nickname"
        }
      }
    }
  }
}

// MARK: - Post related request type
extension RequestType {
  enum PostRequestType {
    case postsFetch
    case postCommentsFetch
    case likedPostsByLoggedInUserFetch
    
    var path: String {
      switch self {
      case .postsFetch:
         "posts"
      case .postCommentsFetch:
        "post/detail"
      case .likedPostsByLoggedInUserFetch:
        "post/like/list"
      }
    }
  }
  
  enum PostNestedCommentRequestType {
    case send
    case update
    case delete
    case heartToggle
    
    var path: String {
      return "comment" + self.relativePath
    }
    
    private var relativePath: String {
      switch self {
      case .send:
        "/nestedComment"
      case .update:
        "/nestedComment"
      case .delete:
        "/nestedComment"
      case .heartToggle:
        "/nestedComment/like"
      }
    }
  }
    
  enum PostCommentRequestType {
    case send
    case update
    case delete
    case fetchComments
    case heartToggle
    
    var path: String {
      if case .heartToggle = self {
        return "comment/like"
      }
      return "comment"
    }
  }
}
