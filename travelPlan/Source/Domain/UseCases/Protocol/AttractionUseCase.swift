//
//  AttractionUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation
import Combine

protocol AttractionUseCase {
  func fetchAttractionDetail(tourContentId: TourContentId) -> AnyPublisher<AttractionEntity, any Error>
}
