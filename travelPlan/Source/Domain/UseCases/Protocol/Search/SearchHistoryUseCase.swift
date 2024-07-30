//
//  SearchHistoryUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

protocol SearchHistoryUseCase {
  func fetchHistories(page: Int?, perPage: Int?) -> AnyPublisher<SearchHistories, any Error>
}
