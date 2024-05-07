//
//  FirestoreEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import SHFirestoreService

final class FirestoreEndpoint<ResponseDTO>: FirestoreEndopintable where ResponseDTO: Decodable {
  var requestDTODictionary: [String: Any]?
  
  // MARK: - Properties
  var requestDTO: (any Encodable)?
  var method: FirestoreMethod
  var requestType: any FirestoreAccessible
  
  // MARK: - Lifecycle
  init(
    requestDTO: (any Encodable)? = nil,
    method: FirestoreMethod,
    requestType: FirestoreRequestType
  ) {
    self.requestDTO = requestDTO
    self.method = method
    self.requestType = requestType
  }
}
