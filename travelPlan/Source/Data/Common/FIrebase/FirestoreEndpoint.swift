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
  var requestDTODictionary: [String : Any]?
  var requestDTO: (any Encodable)?
  var method: FirestoreMethod
  var requestType: any FirestoreAccessible
  
  // MARK: - Lifecycle
  init(
    requestDTODictionary: [String: Any]? = nil,
    requestDTO: (any Encodable)? = nil,
    method: FirestoreMethod,
    requestType: FirestoreRequestType
  ) {
    self.requestDTODictionary = requestDTODictionary
    self.requestDTO = requestDTO
    self.method = method
    self.requestType = requestType
  }
  
  convenience init(
    requestDTODictionary: [String: Any]?,
    method: FirestoreMethod,
    requestType: FirestoreRequestType
  ) {
    self.init(
      requestDTODictionary: requestDTODictionary,
      requestDTO: nil,
      method: method,
      requestType: requestType)
  }
  
  convenience init(
    requestDTO: (any Encodable)?,
    method: FirestoreMethod,
    requestType: FirestoreRequestType
  ) {
    self.init(
      requestDTODictionary: nil,
      requestDTO: requestDTO,
      method: method,
      requestType: requestType)
  }
}
