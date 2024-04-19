//
//  FirestoreServiceError.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import FirebaseFirestore

@frozen public enum FirestoreServiceError: LocalizedError {
  case collectionNotFound
  case docuemntNotfound
  case methodNotSupported
  case invalidFirestoreMethodRequest
}
