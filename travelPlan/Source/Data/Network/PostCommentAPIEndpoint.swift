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
  
  static func updateComment(
    with requestDTO: PostCommentUpdateRequestDTO
  ) -> Endpoint<CommonDTO<PostCommentUpdateResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .put,
      parameters: [.body(requestDTO)],
      requestType: .postComment(.update))
  }
  
  static func deleteComment(
    with requestDTO: PostCommentDeleteRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .delete,
      parameters: [.query(requestDTO)],
      requestType: .postComment(.delete))
  }
}
