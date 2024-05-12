//
//  FirestoreEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import SHFirestoreService

final class FirestoreEndpoint<ResponseDTO>: FirestoreEndopintable where ResponseDTO: Decodable {
  // MARK: - Properties
  var requestDTODictionary: [String: Any]?
  var requestDTO: any Encodable?
  var method: FirestoreMethod
  var requestType: any FirestoreAccessible
  
  // MARK: - Lifecycle
  init(
    requestDTODict: [String: Any]? = nil,
    requestDTO: (any Encodable)? = nil,
    method: FirestoreMethod,
    requestType: FirestoreRequestType
  ) {
    self.requestDTODictionary = requestDTODict
    self.requestDTO = requestDTO
    self.method = method
    self.requestType = requestType
  }
}
