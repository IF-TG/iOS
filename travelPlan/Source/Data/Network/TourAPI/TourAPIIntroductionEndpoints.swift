//
//  TourAPIIntroductionEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

struct TourAPIIntroductionEndpoints {
  private static let tourApiRequestType = TourApiRequestType.introduction
  private init() { }
  
  static func fetchAccommodation(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoAccommodationResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
  
  static func fetchLeports(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoLeportsResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
  
  static func fetchCultureFacility(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoCultureFacilityResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
  
  static func fetchAttraction(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoAttractionResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
  
  static func fetchRestaurant(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoRestaurantResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
  
  static func fetchFestival(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoFestivalResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
  
  static func fetchShopping(
    with requestDTO: TourAPIIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoShoppingResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: tourApiRequestType)
  }
}
