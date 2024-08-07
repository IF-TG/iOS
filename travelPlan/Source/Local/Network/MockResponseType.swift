//
//  MockResponseType.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation

@frozen enum MockResponseType {
  case notice
  case post(PostResponse)
  case postComment(PostCommentResponse)
  case postNestedComment(PostNestedCommentResponse)
  case favoriteDirectory(FavoriteDirectory)
  case destinationRecommend(DestinationRecommend)
  case destinationScrap(DestinationScrapResponse)
  case destination(Destination)
  case destinationLike(DestinationLike)
  case searchHistory(SearchHistoryResponse)
  case getDestination(GetDestination)
  
  var filePath: String {
    return switch self {
    case .notice:
      "mock_response_notice"
    case .postComment(let comment):
      comment.filePath
    case .postNestedComment(let comment):
      comment.filePath
    case .favoriteDirectory(let directoryType):
      directoryType.filePath
    case .post(let response):
      response.filePath
    case .destinationScrap(let response):
      response.filePath
    case .searchHistory(let response):
      response.filePath
    case .destinationLike(let response):
      response.filePath
    case .destination(let response):
      response.filePath
    case .getDestination(let response):
      response.filePath
    }
  }
  
  // MARK: - MockResponseType의 특정 case에 대한 json 디렉터리 -> Data로 불러올 때 사용합니다.
  var mockDataLoader: Data {
    guard let path = Bundle.main.path(forResource: filePath, ofType: "json") else {
      return Data()
    }
    guard let jsonStr = try? String(contentsOfFile: path) else {
      return Data()
    }
    return jsonStr.data(using: .utf8) ?? Data()
  }
}

// MARK: - Post
extension MockResponseType {
  @frozen enum PostResponse {
    case whenPostContainerResponse
    case whenPostCommentContainerResponse
    case whenPostsSearchResponse
    case reviewWritingPostResponse
    
    var filePath: String {
      switch self {
      case .whenPostContainerResponse:
        "mock_response_postContainer"
      case .whenPostCommentContainerResponse:
        "mock_response_postCommentContainer"
      case .whenPostsSearchResponse:
        "mock_posts_response"
      case .reviewWritingPostResponse:
        "mock_reviewWriting_post_response"
      }
    }
  }
}

// MARK: - Comment, NestedComment
extension MockResponseType {
  @frozen enum PostCommentResponse {
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
  
  @frozen enum PostNestedCommentResponse {
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
}

// MARK: - Favorite directory
extension MockResponseType {
  @frozen enum FavoriteDirectory {
    case favoriteTravel(FavoriteTravelDestinationInDirectory)
    case favoritePost(FavoritePostInDirectory)
    
    var filePath: String {
      switch self {
      case .favoritePost(let favoritePost):
        return favoritePost.filePath
      case .favoriteTravel(let favoriteTravelDestination):
        return favoriteTravelDestination.filePath
      }
    }
    
    // MARK: - Nested
    @frozen enum FavoriteTravelDestinationInDirectory {
      case when_____FIXME
      
      var filePath: String {
        [
          .when_____FIXME: "response json file name: ]"
        ] [self]!
      }
    }
    
    @frozen enum FavoritePostInDirectory {
      case whenFavoritePostsFetch
      case whenFavoritePostDirectoryNameUpdate
      
      var filePath: String {
        [
          .whenFavoritePostsFetch: "mock_favoritePosts_fetch_response",
          .whenFavoritePostDirectoryNameUpdate: "mock_favoritePostDirectoryName_update_response"
        ] [self]!
      }
    }
  }
}

extension MockResponseType {
  @frozen enum DestinationScrapResponse {
    case getAllDestinationScrapsByScrapFolderAndUserId
    case toggleDestinationScrap
    case updateDestinationScrap
    case getAllByKeyword
    var filePath: String {
      [
        .getAllDestinationScrapsByScrapFolderAndUserId: "mock_response_getDestinationScrapList",
        .toggleDestinationScrap: "mock_response_toggleDestinationScrap",
        .updateDestinationScrap: "mock_response_updateDestinationScrap",
        .getAllByKeyword: "mock_response_getAllByKeyword"
      ][self]!
    }
  }
}

extension MockResponseType {
  @frozen enum SearchHistoryResponse {
    case recentSearch
    
    var filePath: String {
      [
        .recentSearch: "mock_response_recentSearch"
      ][self]!
    }
  }
}

extension MockResponseType {
  @frozen enum DestinationLike {
    case toggleLikeDestination
    
    var filePath: String {
      [
        .toggleLikeDestination: "mock_response_toggleLikeDestination"
      ][self]!
    }
  }
}

extension MockResponseType {
  @frozen enum Destination {
    case getAllByKeyword
    var filePath: String {
      [
        .getAllByKeyword: "mock_response_getAllByKeyword",
      ][self]!
    }
  }
  
  @frozen enum GetDestination {
    case restaurant
    case festival
    case leports
    case shopping
    case attraction
    case cultureFacility
    
    var filePath: String {
      [
        .restaurant: "mock_response_getDestination_restaurant",
        .festival: "mock_response_getDestination_festival",
        .leports: "mock_response_getDestination_leports",
        .shopping: "mock_response_getDestination_shopping",
        .attraction: "mock_response_getDestination_attraction",
        .cultureFacility: "mock_response_getDestination_cultureFacility"
      ][self]!
    }
  }
}

extension MockResponseType {
  @frozen enum DestinationRecommend {
    case getDestinationRecommend
    
    var filePath: String {
      [
        .getDestinationRecommend: "mock_response_getDestinationRecommend"
      ][self]!
    }
  }
}
