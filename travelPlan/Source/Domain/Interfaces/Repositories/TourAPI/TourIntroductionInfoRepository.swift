//
//  TourIntroductionInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation
import Combine

protocol TourIntroductionInfoRepository {
  func fetchFestival(contentId: Int, contentTypeId: Int) -> AnyPublisher<IntroductionInfoFestivalEntity, any Error>
}
