//
//  MockUrlProtocol+.swift
//  travelPlan
//
//  Created by 양승현 on 10/30/23.
//

import Foundation

extension MockUrlProtocol {
  enum MockResponseDTOType {
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
}
