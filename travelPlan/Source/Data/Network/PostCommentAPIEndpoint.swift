//
//  PostCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostCommentAPIEndpoint {
  static func sendComment(
    with requestDTO: PostCommentSendingRequestDTO
  ) -> Endpoint<CommonDTO<PostCommentResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .postComment(.send))
  }
}
