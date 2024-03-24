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
  
  var filePath: String {
    return switch self {
    case .notice:
      "mock_response_notice"
    case .postComment(let comment):
      comment.filePath
    case .postContainerResponse:
      "mock_response_postContainer"
    case .postCommentContainerResponse:
      "mock_response_postCommentContainer"
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
    
    var filePath: String {
      let dict = [
        .whenCommentSend: "mock_response_postComments_whenCommentSend",
        .whenCommentUpdate: "mock_postComment_update_response",
        .whenCommentDelete: "mock_postComment_delete_response"
      ] as [Self: String]
      return dict[self]!
    }
  }
}
