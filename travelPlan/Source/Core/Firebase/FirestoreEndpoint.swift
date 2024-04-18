//
//  FirestoreEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import FirebaseFirestore

struct FirestoreEndopint<ResponseDTO: Decodable> {
  let ResponseDTO: ResponseDTO
  
  var parameters: (any Encodable)?
  var method: FirestoreMethod
  var requestType: FirestoreRequestType
}

extension FirestoreEndopint {
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
