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
  
  var filePath: String {
    let dict: [Self: String] = [
      .notice: "mock_response_notice.json.",
      .postContainerResponse: "mock_postContainerResponse"
    ]
    return dict[self]!
  }
}
