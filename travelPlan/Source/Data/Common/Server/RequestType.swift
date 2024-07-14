//
//  SubPathType.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation

@frozen enum RequestType: RelativeURLPathProvidable {
  case none
  case login(LoginRequestType)
  case user(UserRequestType)
  case post(PostRequestType)
  case postComment(PostCommentRequestType)
  case postNestedComment(PostNestedCommentRequestType)
  case favoritePostInDirectory(FavoritePostInDirectory)
  case destination(DestinationRequestType)
  
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
    case .favoritePostInDirectory(let favoritePost):
      favoritePost.path
    case .destination(let destination):
      destination.path
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
  @frozen enum PostRequestType {
    case save
    case update
    case postsFetch
    case postCommentsFetch
    case likedPostsByLoggedInUserFetch
    case postSearch
    case toggleLike
    
    var path: String {
      switch self {
      case .postsFetch:
         "posts"
      case .postCommentsFetch:
        "post/detail"
      case .likedPostsByLoggedInUserFetch:
        "post/like/list"
      case .postSearch:
        "post/search"
      case .save, .update:
        "post"
      case .toggleLike:
        "post/like"
      }
    }
  }
  
  @frozen enum PostNestedCommentRequestType {
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
    
  @frozen enum PostCommentRequestType {
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

// MARK: - Favorite
extension RequestType {
  @frozen enum FavoritePostInDirectory {
    case favoritePostsFetch
    case favoritePostToggle
    case favoritePostDirectoryNameUpdate
    
    var path: String {
      switch self {
      case .favoritePostsFetch:
        "post/scrap/detail"
      case .favoritePostToggle:
        "post/scrap"
      case .favoritePostDirectoryNameUpdate:
        "post/scrap"
      }
    }
  }
}

extension RequestType {
  @frozen enum DestinationRequestType {
    case toggleScrap
    case Detail
    case scrapList
    case updateScrap
    case search
    
    var path: String {
      switch self {
      case .toggleScrap, .updateScrap: return "destination/scrap"
      case .Detail: return "destination/detail"
      case .scrapList: return "destination/scrap/detail"
      case .search: return "destination/search"
      }
    }
  }
}
