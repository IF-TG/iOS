//
//  ShoppingUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/15/24.
//

import XCTest
import Combine
@testable import travelPlan

final class ShoppingUseCaseTests: XCTestCase {
  // MARK: - Properties
  private var sut: ShoppingUseCase!
  private var subscriptions: Set<AnyCancellable>!
  private var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultShoppingUseCase(
      tourIntroductionInfoRepository: DefaultTourIntroductionInfoRepository(
        service: SessionProvider(),
        backgroundQueue: DispatchQueue.main
      ),
      tourCommonInfoRepository: DefaultTourCommonInfoRepository(
        service: SessionProvider(),
        imageService: ImageSessionProvider(),
        backgroundQueue: DispatchQueue.main
      ),
      tourImageRetrieveInfoRepository: DefaultTourImageRetrieveInfoRepository(
        service: SessionProvider(),
        imageService: ImageSessionProvider(),
        backgroundQueue: DispatchQueue.main
      )
    )
    expectation = .init(description: "service 비동기 호출")
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    expectation = nil
    subscriptions = nil
  }
}

// MARK: - Tests
extension ShoppingUseCaseTests {
  func test_fetchShoppingDetail메소드_호출시_receivedValue로_ShoppingEntity를_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let shoppingId = TourContentId(contentId: 2783811, contentTypeId: TourType.shopping.rawValue)
    
    // Act
    sut.fetchShoppingDetail(tourContentId: shoppingId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] shoppingEntity in
        print("shoppingEntity: \(shoppingEntity)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchShoppingDetail")
    XCTAssertTrue(receivedResult, "receivedValue로 ShoppingEntity를 받아야 하는데, 받지 못함.")
  }
}
