//
//  FirestoreMethod.swift
//  travelPlan
//
//  Created by 양승현 on 4/18/24.
//

import Foundation
import FirebaseFirestore

@frozen enum FirestoreMethod {
  case get
  case save(Encodable)
  case delete
  case update(Encodable)
  case query
}
