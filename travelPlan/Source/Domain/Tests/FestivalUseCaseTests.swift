//
//  FestivalUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/14/24.
//

import XCTest
import Combine
@testable import travelPlan

final class FestivalUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: FestivalUseCase!
  var subscriptions: Set<AnyCancellable>!
  var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = DefaultFestivalUseCase(
      tourFestivalInfoRepository: DefaultTourFestivalInfoRepository(
        service: SessionProvider(),
        imageService: ImageSessionProvider(),
        backgroundQueue: DispatchQueue.main
      ),
      tourCommonInfoRepository: DefaultTourCommonInfoRepository(
        service: SessionProvider(),
        imageService: ImageSessionProvider(),
        backgroundQueue: DispatchQueue.main
      ),
      tourIntroductionInfoRepository: DefaultTourIntroductionInfoRepository(
        service: SessionProvider(),
        backgroundQueue: DispatchQueue.main
      ), 
      tourImageRetrieveInfoRepository: DefaultTourImageRetrieveInfoRepository(
        service: SessionProvider(),
        imageService: ImageSessionProvider(),
        backgroundQueue: DispatchQueue.main
      )
    )
    
    expectation = .init(description: "비동기 처리")
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions = nil
    expectation = nil
  }
}

// MARK: - Test
extension FestivalUseCaseTests {
  func test_fetchFestivalList메소드_호출시_FestivalThumbnailEntity배열을_내려주는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    
    // Act
    sut.fetchFestivalList()
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] festivalThumbnailEntities in
        print("festivalThumbnailEntities: \(festivalThumbnailEntities)")
        receivedResult = true
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 10)

    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFestivalList")
    XCTAssertTrue(receivedResult, "receviedValue로 FestivalThumbnailEntity배열을 받지 못함.")
  }
  
  func test_fetchFestivalDetail메소드_호출시_receivedValue로FestivalEntity받아오는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedResult = false
    let festivalId = TourContentId(contentId: 531391, contentTypeId: TourType.festival.rawValue)
    
    // Act
    sut.fetchFestivalDetail(tourContentId: festivalId)
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self?.expectation.fulfill()
        }
      } receiveValue: { [weak self] festivalEntity in
        receivedResult = true
        print("festivalEntity: \(festivalEntity)")
        self?.expectation.fulfill()
      }
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFestivalDetail")
    XCTAssertTrue(receivedResult, "receivedValue로 FestiavlEntity를 받아야하는데 받지 못함.")
  }
}
