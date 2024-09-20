//
//  DestinationRecommendUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 8/11/24.
//

import Foundation
import Combine

protocol DestinationRecommendUseCase {
  func fetchDestinationList(
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[DestinationRecommendSection], any Error>
  
  func toggleDestinationScrap(
    id: Int,
    folderName: String?
  ) -> AnyPublisher<DestinationScrapToggler, any Error>
}
