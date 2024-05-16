//
//  TourIntroductionInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation
import Combine

protocol TourIntroductionInfoRepository {
  func fetchLeports(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoLeportsEntity, any Error>
  
  func fetchCultureFacility(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoCultureFacilityEntity, any Error>
  
  func fetchAttratcion(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoAttractionEntity, any Error>
  
  func fetchRestaurant(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoRestaurantEntity, any Error>
  
  func fetchFestival(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoFestivalEntity, any Error>
  
  func fetchShopping(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoShoppingEntity, any Error>
  
  func fetchAccommodation(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoAccommodationEntity, any Error>
}
