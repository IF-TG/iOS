//
//  FirestoreDataLocationable.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import FirebaseFirestore

protocol FirestoreDataLocationable {
  var collectionRef: CollectionReference { get }
  var documentRef: DocumentReference? { get }
}
