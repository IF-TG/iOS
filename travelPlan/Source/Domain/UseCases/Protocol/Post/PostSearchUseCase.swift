//
//  PostSearchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Foundation
import Combine

protocol PostSearchUseCase {
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], Error>
}
