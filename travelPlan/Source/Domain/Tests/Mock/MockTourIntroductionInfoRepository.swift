//
//  MockTourIntroductionInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 5/14/24.
//

import Foundation
import Combine

final class MockTourIntroductionInfoRepository {
  // MARK: - Properties
  private let repository: TourIntroductionInfoRepository
  
  init(backgroundQueue: DispatchQueue) {
    let service = SessionProvider(session: MockSession.default)
    self.repository = DefaultTourIntroductionInfoRepository(service: service, backgroundQueue: backgroundQueue)
  }
}

// MARK: - TourIntroductionInfoRepository
extension MockTourIntroductionInfoRepository: TourIntroductionInfoRepository {
  func fetchAccommodation(tourContentId: TourContentId) 
  -> AnyPublisher<IntroductionInfoAccommodationEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.accommodation).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 136605, contentTypeId: TourType.accommodation.rawValue)
    return repository.fetchAccommodation(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchLeports(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoLeportsEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.leports).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 2792802, contentTypeId: TourType.leports.rawValue)
    return repository.fetchLeports(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchCultureFacility(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoCultureFacilityEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.cultureFacility).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 129877, contentTypeId: TourType.cultureFacility.rawValue)
    return repository.fetchCultureFacility(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchAttratcion(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoAttractionEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.attraction).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 126273, contentTypeId: TourType.attraction.rawValue)
    return repository.fetchAttratcion(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchRestaurant(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoRestaurantEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.restaurant).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 2901530, contentTypeId: TourType.restaurant.rawValue)
    return repository.fetchRestaurant(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  /// contentId와 contentTypeId를 주석과 같이 고정합니다.
  /// - contentId: 1806376
  /// - contentTypeId: 15
  func fetchFestival(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoFestivalEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.festival).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 1806376, contentTypeId: TourType.festival.rawValue)
    return repository.fetchFestival(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchShopping(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoShoppingEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = TourAPIMockResponseType.introdution(.shopping).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 2930927, contentTypeId: TourType.shopping.rawValue)
    return repository.fetchShopping(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
}
