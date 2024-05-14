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
  
  init() {
    let service = SessionProvider(session: MockSession.default)
    self.repository = DefaultTourIntroductionInfoRepository(service: service)
  }
}

// MARK: - TourIntroductionInfoRepository
extension MockTourIntroductionInfoRepository: TourIntroductionInfoRepository {
  func fetchLeports(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoLeportsEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.tourAPI(.introduction(.leports)).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 2792802, contentTypeId: TourType.leports.rawValue)
    return repository.fetchLeports(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchCultureFacility(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoCultureFacilityEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.tourAPI(.introduction(.cultureFacility)).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 129877, contentTypeId: TourType.cultureFacility.rawValue)
    return repository.fetchCultureFacility(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchAttratcion(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoAttractionEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.tourAPI(.introduction(.attraction)).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 126273, contentTypeId: TourType.attraction.rawValue)
    return repository.fetchAttratcion(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchRestaurant(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoRestaurantEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.tourAPI(.introduction(.restaurant)).mockDataLoader
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
      let mockData = MockResponseType.tourAPI(.introduction(.festival)).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 1806376, contentTypeId: TourType.festival.rawValue)
    return repository.fetchFestival(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
  
  func fetchShopping(tourContentId: TourContentId) -> AnyPublisher<IntroductionInfoShoppingEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.tourAPI(.introduction(.shopping)).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    let tourContentId = TourContentId(contentId: 2930927, contentTypeId: TourType.shopping.rawValue)
    return repository.fetchShopping(tourContentId: tourContentId)
      .eraseToAnyPublisher()
  }
}
