//
//  PostNestedCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation

struct PostNestedCommentAPIEndpoint {
  static func sendNestedComment(with requestDTO: PostNestedCommentSendRequestDTO
  ) -> Endpoint<CommonDTO<PostNestedCommentResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .postNestedComment(.send))
  }
}
