//
//  DefaultTourDesrinationUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

final class DefaultTourDesrinationUseCase: TourCommonInfoUseCase {
  
  // MARK: - Dependencies
  let tourDestinationRepository: TourCommonInfoRepository
  
  // MARK: - Lifecycle
  init(tourDestinationRepository: TourCommonInfoRepository) {
    self.tourDestinationRepository = tourDestinationRepository
  }
  
  // MARK: - Helpers
  /// 특정 contentId에 대한 반환타입은 1 or error입니다..
  func fetchCommonInfo(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<TourCommonInfoEntity, any Error> {
    return tourDestinationRepository
      .fetchTourCommonInfo(contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
      .compactMap { entities in
        entities.first
      }.eraseToAnyPublisher()
  }
}
