//
//  DefaultTourIntroductionInfoRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/8/24.
//

import XCTest
import Combine
@testable import travelPlan

final class DefaultTourIntroductionInfoRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: TourIntroductionInfoRepository!
  var subscriptions: Set<AnyCancellable>!
  var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultTourIntroductionInfoRepository(
      service: TourApiSessionProvider(),
      backgroundQueue: DispatchQueue.main
    )
    subscriptions = .init()
    expectation = .init(description: "비동기 호출 관리")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions = nil
    expectation = nil
  }
}

extension DefaultTourIntroductionInfoRepositoryTests {
  /* 숙박 */
  func test_fetchAccommodation메소드_호출시_value로_IntroductionInfoAccommodationEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let tourContentId = TourContentId(contentId: 136605, contentTypeId: TourType.accommodation.rawValue)
    
    // Act
    let actPublisher = sut.fetchAccommodation(tourContentId: tourContentId)
    
    sink(
      fromPublisher: actPublisher,
      withExpectation: expectation
    ) { error, result in
        unexpectedError = error
        receivedResult = result
      }
    .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchAccommodation")
    XCTAssertTrue(receivedResult, "receivedValue로 IntroductionInfoAccommodationEntity를 받아야하는데 받지 못함.")
  }
  
  /* 쇼핑 */
  func test_fetchShopping메소드_호출시_value로_IntroductionInfoShoppingEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let tourContentId = TourContentId(contentId: 2900895, contentTypeId: TourType.shopping.rawValue)
    
    // Act
    sut.fetchShopping(tourContentId: tourContentId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] entity in
        print("entity: \(entity)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchShopping")
    XCTAssertTrue(receivedResult, "receivedValue로 IntroductionInfoShoppingEntity가 들어오지 않았습니다.")
  }
  
  /* 행사/축제/공연 */
  func test_fetchFestival메소드_호출시_value로_IntroductionInfoFestivalEntity를_내려주면_shouldReturnTrue() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let tourContentId = TourContentId(contentId: 3114721, contentTypeId: TourType.festival.rawValue)
    
    // Act
    sut.fetchFestival(tourContentId: tourContentId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] entity in
        print("entity: \(entity)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFestival")
    XCTAssertTrue(receivedResult, "receiveValue가 들어와야하는데 들어오지 않음")
  }
  
  /* 음식점 */
  func test_fetchRestaurant메소드_호출시_value로_IntroductionInfoRestaurantEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let restaurantId = TourContentId(contentId: 2831563,
                                     contentTypeId: TourType.restaurant.rawValue)
    
    // Act
    sut.fetchRestaurant(tourContentId: restaurantId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] restaurantEntity in
        print(restaurantEntity)
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchRestaurant")
    XCTAssertTrue(receivedResult, "IntroductionInfoRestaurantEntity가 들어와야하는데, 들어오지 않음.")
  }
  
  /* 관광지 */
  func test_fetchAttraction메소드_호출시_value로_IntroductionInfoAttractionEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let attractionId = TourContentId(contentId: 3018842, contentTypeId: TourType.attraction.rawValue)
    
    // Act
    sut.fetchAttratcion(tourContentId: attractionId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] entity in
        print("attraction entity: \(entity)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchAttratcion")
    XCTAssertTrue(receivedResult, "receivedValue로 IntroductionInfoAttractionEntity를 받아야 하는데, 받지 못함.")
  }
  
  /* 문화시설 */
  func test_fetchCultureFacility메소드_호출시_value로_IntroductionInfoCultureFacilityEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let cultureFacilityId = TourContentId(contentId: 130217, contentTypeId: TourType.cultureFacility.rawValue)
    
    // Act
    sut.fetchCultureFacility(tourContentId: cultureFacilityId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] entity in
        print("receivedValue: \(entity)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchCultureFacility")
    XCTAssertTrue(receivedResult, "receivedValue로 IntroductionInfoCultureFacilityEntity를 받아야 하는데, 받지 못함.")
  }
  
  /* 레포츠 */
  func test_fetchLeports메소드_호출시_value로_IntroductionInfoLeportsEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let leportsId = TourContentId(contentId: 2726713, contentTypeId: TourType.leports.rawValue)
    
    // Act
    sut.fetchLeports(tourContentId: leportsId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] leportEntity in
        print(leportEntity)
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)

    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchLeports")
    XCTAssertTrue(receivedResult, "receivedValue로 IntroductionInfoLeportsEntity를 받아야 하는데, 받지 못함.")
  }
}
