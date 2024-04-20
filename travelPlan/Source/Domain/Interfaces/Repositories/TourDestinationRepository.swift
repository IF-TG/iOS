//
//  TourDestinationRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

protocol TourDestinationRepository {
  func fetchTourDestinationDetailCommon(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<TourDestinationDetailCommonEntity, Error>
}
