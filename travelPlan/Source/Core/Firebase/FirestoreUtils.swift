//
//  FirestoreUtils.swift
//  travelPlan
//
//  Created by 양승현 on 4/18/24.
//

import FirebaseFirestore
import FirebaseAuth

protocol FirestoreUtils {}

extension FirestoreUtils {
  var db: Firestore {
    return Firestore.firestore()
  }
  
  func reference(with type: FirestoreCollectionType) -> CollectionReference {
    return db.collection(type.rawValue)
  }
  
  var auth: Auth {
    return Auth.auth()
  }
}
