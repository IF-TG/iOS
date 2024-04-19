//
//  FirestoreQueryModifiable.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import FirebaseFirestore

protocol FirestoreQueryModifiable {
  var field: String { get }
  var value: Any { get }
  
  func apply(to query: Query) -> Query
}
