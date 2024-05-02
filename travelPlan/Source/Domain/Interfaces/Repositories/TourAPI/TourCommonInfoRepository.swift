//
//  TourCommonInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

protocol TourCommonInfoRepository {
  func fetchTourCommonInfo(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<TourCommonInfoEntity, Error>
}
