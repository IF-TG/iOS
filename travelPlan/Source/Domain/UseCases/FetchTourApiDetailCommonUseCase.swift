//
//  FetchTourApiDetailCommonUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

final class FetchTourApiDetailCommonUseCase: TourApiDetailCommonUseCase {
  
  // MARK: - Dependencies
  let tourDestinationRepository: TourDetailCommonRepository
  
  // MARK: - Lifecycle
  init(tourDestinationRepository: TourDetailCommonRepository) {
    self.tourDestinationRepository = tourDestinationRepository
  }
  
  // MARK: - Helpers
  /// 특정 contentId에 대한 반환타입은 1 or error입니다..
  func fetchDetailCommonInfo(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<TourDestinationDetailCommonEntity, any Error> {
    return tourDestinationRepository
      .fetchTourDestinationDetailCommon(contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
      .compactMap { entities in
        entities.first
      }.eraseToAnyPublisher()
  }
}
