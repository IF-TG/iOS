//
//  DefaultTourIntroductionInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation
import Combine

final class DefaultTourIntroductionInfoRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - IntroductionInfoRepository
extension DefaultTourIntroductionInfoRepository: TourIntroductionInfoRepository {
  /// 여행 코스
  func fetchCourse(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoCourseEntity, any Error> {
    let requestDTO = TourAPIIntroductionInfoRequestDTO(contentId: tourContentId.contentId,
                                                       contentTypeId: tourContentId.contentTypeId)
    let endpoint = TourAPIIntroductionEndpoints.fetchCourse(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  /// 숙박
  func fetchAccommodation(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoAccommodationEntity, any Error> {
    let requestDTO = TourAPIIntroductionInfoRequestDTO(contentId: tourContentId.contentId,
                                                       contentTypeId: tourContentId.contentTypeId)
    let endpoint = TourAPIIntroductionEndpoints.fetchAccommodation(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  /// 레포츠
  func fetchLeports(tourContentId: TourContentId) 
  -> AnyPublisher<IntroductionInfoLeportsEntity, any Error> {
    let requestDTO = TourAPIIntroductionInfoRequestDTO(contentId: tourContentId.contentId,
                                                       contentTypeId: tourContentId.contentTypeId)
    let endpoint = TourAPIIntroductionEndpoints.fetchLeports(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  /// 문화시설
  func fetchCultureFacility(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoCultureFacilityEntity, any Error> {
    let requestDTO = TourAPIIntroductionInfoRequestDTO(contentId: tourContentId.contentId,
                                                       contentTypeId: tourContentId.contentTypeId)
    let endpoint = TourAPIIntroductionEndpoints.fetchCultureFacility(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  /// 관광지
  func fetchAttratcion(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoAttractionEntity, any Error> {
    let requestDTO = TourAPIIntroductionInfoRequestDTO(contentId: tourContentId.contentId,
                                                       contentTypeId: tourContentId.contentTypeId)
    let endpoint = TourAPIIntroductionEndpoints.fetchAttraction(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  /// 음식점
  func fetchRestaurant(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoRestaurantEntity, any Error> {
    let requestDTO = TourAPIIntroductionInfoRequestDTO(
      contentId: tourContentId.contentId,
      contentTypeId: tourContentId.contentTypeId
    )
    let endpoint = TourAPIIntroductionEndpoints.fetchRestaurant(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }

  /// 쇼핑
  func fetchShopping(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoShoppingEntity, any Error> {
    let endpoint = TourAPIIntroductionEndpoints.fetchShopping(with: .init(
      contentId: tourContentId.contentId, 
      contentTypeId: tourContentId.contentTypeId
    ))
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
  
  /// 행사/축제/공연
  func fetchFestival(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoFestivalEntity, any Error> {
    let endpoint = TourAPIIntroductionEndpoints.fetchFestival(with: .init(
      contentId: tourContentId.contentId,
      contentTypeId: tourContentId.contentTypeId
    ))
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tourAPITryMapResponseDTO()
      .map { $0.toDomain() }
      .eraseToAnyPublisher()
  }
}
