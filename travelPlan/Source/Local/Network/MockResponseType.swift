//
//  MockResponseType.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation

enum MockResponseType {
  case notice
  case postContainerResponse
  case postCommentContainerResponse
  case postComment(PostCommentResponse)
  case postNestedComment(PostNestedCommentResponse)
  case userBlock(UserBlock)
  case favoriteDirectory(FavoriteDirectory)
  
  var filePath: String {
    return switch self {
    case .notice:
      "mock_response_notice"
    case .postComment(let comment):
      comment.filePath
    case .postNestedComment(let comment):
      comment.filePath
    case .postContainerResponse:
      "mock_response_postContainer"
    case .postCommentContainerResponse:
      "mock_response_postCommentContainer"
    case .userBlock(let userBlock):
      userBlock.filePath
    case .favoriteDirectory(let directoryType):
      switch directoryType {
      case .favoriteTravel(let favoriteTravelDestinationInDirectory):
        favoriteTravelDestinationInDirectory.filePath
      case .favoritePost(let favoritePostInDirectory):
        favoritePostInDirectory.filePath
      }
    }
  }
  
  var mockDataLoader: Data {
    guard let path = Bundle.main.path(forResource: filePath, ofType: "json") else {
      return Data()
    }
    guard let jsonStr = try? String(contentsOfFile: path) else {
      return Data()
    }
    return jsonStr.data(using: .utf8) ?? Data()
  }
  
  enum PostCommentResponse {
    case whenCommentSend
    case whenCommentUpdate
    case whenCommentDelete
    case whenCommentsFetch
    case whenCommentHeartToggle
    
    var filePath: String {
      let dict = [
        .whenCommentSend: "mock_response_postComments_whenCommentSend",
        .whenCommentUpdate: "mock_postComment_update_response",
        .whenCommentDelete: "mock_postComment_delete_response",
        .whenCommentsFetch: "mock_postComment_fetchComments_response",
        .whenCommentHeartToggle: "mock_postComment_toggleCommentHeart_response"
      ] as [Self: String]
      return dict[self]!
    }
  }
  
  enum PostNestedCommentResponse {
    case whenCommentSend
    case whenCommentUpdate
    case whenCommentDelete
    
    var filePath: String {
      [
        .whenCommentSend: "mock_postNestedComment_send_response",
        .whenCommentUpdate: "mock_postNestedComment_update_response",
        .whenCommentDelete: "mock_postNestedComemnt_delete_response"
      ] [self]!
    }
  }
  
  enum UserBlock {
    case whenUserBlock
    case whenBlockedUsersFetch
    
    var filePath: String {
      [
        .whenUserBlock: "mock_userBlock_response",
        .whenBlockedUsersFetch: "mock_blockedUsers_response"
      ] [self]!
    }
  }
}

// MARK: - Favorite directory
extension MockResponseType {
  enum FavoriteDirectory {
    case favoriteTravel(FavoriteTravelDestinationInDirectory)
    case favoritePost(FavoritePostInDirectory)
  }
  
  enum FavoriteTravelDestinationInDirectory {
    case when_____FIXME
    
    var filePath: String {
      [
        .when_____FIXME: "response json file name: ]"
      ] [self]!
    }
  }
  
  enum FavoritePostInDirectory {
    case whenFavoritePostsFetch
    
    var filePath: String {
      [
        .whenFavoritePostsFetch: "mock_favoritePosts_fetch_response"
      ] [self]!
    }

  }
}
