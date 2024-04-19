//
//  DefaultFirestoreService.swift
//  travelPlan
//
//  Created by 양승현 on 4/19/24.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

final class DefaultFirestoreService: FirestoreService {
  func request<D, E>(endpoint: E) -> AnyPublisher<[D], any Error>
  where D == E.ResponseDTO, E : FirestoreEndopintable {
    guard let collectionRef = endpoint.reference as? CollectionReference else {
      return Fail(error: FirestoreServiceError.collectionNotFound).eraseToAnyPublisher()
    }
    if case .get = endpoint.method {
      return collectionRef.getDocuments()
        .tryMap { snapshots in
          try snapshots.documents.map { snapshot in
            try snapshot.data(as: D.self)
          }
        }.eraseToAnyPublisher()
    }
    return Fail(error: FirestoreServiceError.docuemntNotfound).eraseToAnyPublisher()
  }
  
  func request<D, E>(endpoint: E) -> AnyPublisher<D, any Error>
  where D == E.ResponseDTO, E : FirestoreEndopintable {
    guard let documentRef = endpoint.reference as? DocumentReference else {
      return Fail(error: FirestoreServiceError.docuemntNotfound).eraseToAnyPublisher()
    }
    if case .get = endpoint.method {
      return documentRef.getDocument()
        .tryMap { snapshot in
          try snapshot.data(as: D.self)
        }.eraseToAnyPublisher()
    }
    return Fail(error: FirestoreServiceError.docuemntNotfound).eraseToAnyPublisher()
  }
}
