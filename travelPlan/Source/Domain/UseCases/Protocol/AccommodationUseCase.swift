//
//  AccommodationUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation
import Combine

protocol AccommodationUseCase {
  func fetchAccommodationDetail(tourContentId: TourContentId)
  -> AnyPublisher<AccommodationEntity, any Error>
}
