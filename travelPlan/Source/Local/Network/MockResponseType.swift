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
  
  var filePath: String {
    let dict: [Self: String] = [
      .notice: "mock_response_notice",
      .postContainerResponse: "mock_response_postContainer",
      .postCommentContainerResponse: "mock_response_postCommentContainer"
    ]
    return dict[self]!
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
}
