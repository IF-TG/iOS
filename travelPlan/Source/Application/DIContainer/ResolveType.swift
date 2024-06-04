//
//  ResolveType.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation

@frozen enum ResolveType {
  case implementation(ImplementationResolveType)
  case testDouble(TestDoubleResolveType)
}


@frozen enum ImplementationResolveType: String {
  /// Spring server와 통신하는 구현체.
  case `default`
  /// Firestore와 통신하는 구현체
  case firestore
}

@frozen enum TestDoubleResolveType: String {
  case mock, stub, dummy
}
