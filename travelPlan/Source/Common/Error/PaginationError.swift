//
//  PaginationError.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Foundation

/// 페이징을 할 때 발생할 수 있는 에러입니다.
@frozen enum PaginationError: Swift.Error {
  case noMorePage
  case invalidPageNumberError
}
