//
//  FirestoreService.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import Combine
import FirebaseFirestore

final class FirestoreService {
  static func request<ResponseDTO>(
    _ endpoint: any FirestoreEndopint
  ) -> AnyPublisher<ResponseDTO, Error> {
    if endpoint.reference is CollectionReference {
      guard let collectionRef = endpoint.reference as? CollectionReference else {
        return Fail(error: FirestoreServiceError.collectionNotFound)
          .eraseToAnyPublisher()
      }
      // TODO: - 도큐들 반환하자
    } else {
      guard let documentRef = endpoint.reference as? DocumentReference else {
        return Fail(error: FirestoreServiceError.docuemntNotfound)
          .eraseToAnyPublisher()
      }
      // TODO: - 문서 반환하자.
    }
  }
}
