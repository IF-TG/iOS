//
//  TourIntroductionInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation
import Combine

protocol TourIntroductionInfoRepository {
  func fetchAttratcion(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoAttractionEntity, any Error>
  func fetchRestaurant(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoRestaurantEntity, any Error>
  func fetchFestival(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoFestivalEntity, any Error>
  func fetchShopping(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoShoppingEntity, any Error>
}
