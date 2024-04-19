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
  /// 다중 문서 받아올 경우
  func request<D, E>(endpoint: E) -> AnyPublisher<[D], any Error>
  where D == E.ResponseDTO, E: FirestoreEndopintable {
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
  
  /// 단일 문서 받아올 경우
  func request<D, E>(endpoint: E) -> AnyPublisher<D, any Error>
  where D == E.ResponseDTO, E: FirestoreEndopintable {
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
  
  /// Use this method when firestoreMethod is one of save, delete or update
  func request(
    endpoint: any FirestoreEndopintable
  ) -> AnyPublisher<Void, any Error> {
    guard let documentRef = endpoint.reference as? DocumentReference else {
      return Fail(error: FirestoreServiceError.docuemntNotfound).eraseToAnyPublisher()
    }
    switch endpoint.method {
    case .save(let requestDTO):
      return documentRef.setData(from: requestDTO).eraseToAnyPublisher()
    case .delete:
      return documentRef.delete().eraseToAnyPublisher()
    case .update(let requestDTO):
      return documentRef.setData(from: requestDTO).eraseToAnyPublisher()
    default:
      return Fail(error: FirestoreServiceError.invalidFirestoreMethodRequest).eraseToAnyPublisher()
    }
  }
  
  /// If there is only one query condition, you should use **makeQuery** to create the Query.
  /// If there are multiple query conditions, create the Query using **makeQuery** and then add the remaining query conditions using **additionalQueries**.
  func query<D, E>(
    endpoint: E,
    makeQuery: any FirestoreQueryMakeable,
    additionalQueries: [any FirestoreQueryAppendable] = []
  ) -> AnyPublisher<[D], any Error> where D == E.ResponseDTO, E: FirestoreEndopintable {
    guard case .query = endpoint.method else {
      return Fail(error: FirestoreServiceError.invalidFirestoreMethodRequest).eraseToAnyPublisher()
    }
    guard let collectionRef = endpoint.reference as? CollectionReference else {
      return Fail(error: FirestoreServiceError.collectionNotFound).eraseToAnyPublisher()
    }
    let query = makeQuery.makeQuery(with: collectionRef)
    appendQueries(query, queries: additionalQueries)
    return query.getDocuments()
      .tryMap { querySnapshot in
        try querySnapshot.documents.map { snapshot in
          try snapshot.data(as: D.self)
        }
      }.eraseToAnyPublisher()
  }
}
