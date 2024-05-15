//
//  RestaurantUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation
import Combine

protocol RestaurantUseCase {
  func fetchRestaurantDetail(tourContentId: TourContentId) -> AnyPublisher<RestaurantEntity, any Error>
}
