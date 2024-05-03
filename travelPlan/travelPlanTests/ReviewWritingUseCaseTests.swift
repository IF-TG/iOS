//
//  ReviewWritingUseCaseTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 4/20/24.
//

import XCTest
import Combine
@testable import travelPlan

final class ReviewWritingUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: ReviewWritingUseCase!
  var mockRepository: ReviewWritingRepository!
  var subscription: AnyCancellable?
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    mockRepository = MockReviewWritingRepository()
    sut = DefaultReviewWritingUseCase(reviewWritingRepository: mockRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    mockRepository = nil
    subscription = nil
    
  }
}

// MARK: - Tests
extension ReviewWritingUseCaseTests {
  func testReviewWritingUseCase_savePost함수호출시_true를반환하면_shouldReturnTrue() {
    // Arrange
    let entity = ReviewWritingEntity(
      postId: "123",
      category: .init(themes: [.adventure, .campingGlamping],
                      regions: [.busan],
                      seasons: [.spring],
                      partners: [.family]),
      tripDate: .init(start: "2023", end: "2024"),
      title: "제목입니다.",
      contents: [.text("텍스트1"),
                 .image(Data()),
                 .text("텍스트2"),
                 .image(Data()),
                 .image(Data())]
    )
    
    var unexpectedError: Error?
    var expectation = XCTestExpectation(description: "usecase received isSaved true")
    var result = false
    
    // Act
    subscription = sut.savePost(entity: entity)
      .sink { completion in
        if case let .failure(error) = completion {
          unexpectedError = error
        }
      } receiveValue: { isSaved in
        // 현재는 isSaved가 반드시 true입니다.
        if isSaved {
          result = true
          expectation.fulfill()
        }
      }
    
    wait(for: [expectation], timeout: 5.0)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "savePost")
    XCTAssertTrue(result)
  }
  
  func testReviewWritingUseCase_updatePost함수호출시_Post를반환하면_shouldReturnTrue() {
    // Arrange
    let entity = ReviewWritingEntity(
      postId: "123",
      category: .init(themes: [.adventure, .campingGlamping],
                      regions: [.busan],
                      seasons: [.spring],
                      partners: [.family]),
      tripDate: .init(start: "2023", end: "2024"),
      title: "제목입니다.",
      contents: [.text("텍스트1"),
                 .image(Data()),
                 .text("텍스트2"),
                 .image(Data()),
                 .image(Data())]
    )
    let requestValue = ReviewWritingUseCaseUpdateRequestValue(entity: entity, postId: "1234")
    let expectation = XCTestExpectation(description: "usecase received post")
    var unexpectedError: Error?
    var result = false
    
    // Act
    subscription = sut.updatePost(requestValue: requestValue)
      .sink { completion in
        if case let .failure(error) = completion {
          unexpectedError = error
        }
      } receiveValue: { post in
        result = true
        expectation.fulfill()
      }
    
    wait(for: [expectation], timeout: 5.0)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updatePost")
    XCTAssertTrue(result)
  }
}
