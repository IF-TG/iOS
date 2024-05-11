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
  var sut: DefaultTourIntroductionInfoRepository!
  var subscriptions: Set<AnyCancellable>!
  var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = .init(service: SessionProvider())
    subscriptions = .init()
    expectation = .init(description: "비동기 호출 관리")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
    expectation = nil
  }
}

extension DefaultTourIntroductionInfoRepositoryTests {
  // 쇼핑
  func test_fetchShopping메소드_호출시_value로_IntroductionInfoShoppingEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let tourContentId = TourContentId(contentId: 2900895, contentTypeId: TourType.shopping.rawValue)
    
    // Act
    sut.fetchShopping(tourContentId: tourContentId)
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
  
  // 행사/축제/
  func test_fetchFestival메소드_호출시_value로_IntroductionInfoFestivalEntity를_내려주면_shouldReturnTrue() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let tourContentId = TourContentId(contentId: 3114721, contentTypeId: TourType.festival.rawValue)
    
    // Act
    sut.fetchFestival(tourContentId: tourContentId)
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
  
  // 음식점
  func test_fetchRestaurant메소드_호출시_value로_IntroductionInfoRestaurantEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let restaurantId = TourContentId(contentId: 2831563,
                                     contentTypeId: TourType.restaurant.rawValue)
    
    // Act
    sut.fetchRestaurant(tourContentId: restaurantId)
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
}
