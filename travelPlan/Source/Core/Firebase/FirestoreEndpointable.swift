//
//  FirestoreEndpointable.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import FirebaseFirestore

protocol FirestoreEndopintable {
  associatedtype ResponseDTO: Decodable
  
  var parameters: (any Encodable)? { get }
  var method: FirestoreMethod { get }
  var requestType: FirestoreDataLocationable { get }
}

extension FirestoreEndopintable {
  var firestore: Firestore {
    Firestore.firestore()
  }
  
  /// DocuemntRef가 존재하지 않는다면 endpoint에서 collection에 대한 reqeust를 이용하는 것으로 간주합니다.
  var reference: FirestoreReference {
    guard let documentRef = requestType.documentRef else {
      return requestType.collectionRef
    }
    return documentRef
  }
}
