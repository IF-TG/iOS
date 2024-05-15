//
//  CultureFacilityUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation
import Combine

protocol CultureFacilityUseCase {
  func fetchCultureFacility(tourContentId: TourContentId) -> AnyPublisher<CultureFacilityEntity, any Error>
}
