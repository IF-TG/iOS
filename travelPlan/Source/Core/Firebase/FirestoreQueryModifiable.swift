//
//  FirestoreQueryModifiable.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import FirebaseFirestore

protocol FirestoreQuery {
  associatedtype Value: Any
  var field: String { get }
  var value: Value { get }
}

protocol FirestoreQueryAppendable: FirestoreQuery {
  func apply(to query: Query)
}

protocol FirestoreQueryMakeable: FirestoreQuery {
  func makeQuery(with reference: CollectionReference) -> Query
}
