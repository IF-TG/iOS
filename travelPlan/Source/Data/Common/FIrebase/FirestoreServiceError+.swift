//
//  FirestoreServiceError+.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Foundation
import SHFirestoreService

extension FirestoreServiceError {
  /// FirestoreServiceError가 noMorePage에러인 경우 PaginationError.noMorePage를 type erase해서 방출합니다.
  /// 그렇지 않을 경우 FirestoreServiceError를 방출합니다.
  var noMorePagesAsError: Error {
    if case .noMorePage = self {
      return PaginationError.noMorePage
    }
    return self
  }
}

