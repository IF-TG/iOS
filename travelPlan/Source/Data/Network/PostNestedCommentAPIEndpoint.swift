//
//  PostNestedCommentAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation

struct PostNestedCommentAPIEndpoint {
  static func sendNestedComment(
    with requestDTO: PostNestedCommentSendRequestDTO
  ) -> Endpoint<CommonDTO<PostNestedCommentResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .postNestedComment(.send))
  }
  
  static func updateNestedComment(
    with requestDTO: PostNestedCommentUpdateRequestDTO
  ) -> Endpoint<CommonDTO<PostUpdatedNestedCommentResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .put,
      parameters: [.body(requestDTO)],
      requestType: .postNestedComment(.update))
  }
  
  static func deleteNestedComment(
    with requestDTO: PostNestedCommentDeleteRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .delete,
      parameters: [.query(requestDTO)], 
      requestType: .postNestedComment(.delete))
  }
}
