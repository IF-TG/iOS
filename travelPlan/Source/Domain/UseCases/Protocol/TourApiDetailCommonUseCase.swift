//
//  TourDestinationUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

protocol TourApiDetailCommonUseCase {
  func fetchDetailCommonInfo(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<TourDestinationDetailCommonEntity, any Error>
}
