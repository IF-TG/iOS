//
//  FavoritePostInDirectoryUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/4/24.
//

import XCTest
import Combine
@testable import travelPlan

final class FavoritePostInDirectoryUseCaseTests: XCTestCase {
  // MARK: - Properties
  var sut: FavoritePostInDirectoryUseCase!
  var mockRepository: FavoritePostInDirectoryRepository!
  var subscription: AnyCancellable?
  var expectation: XCTestExpectation!
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    mockRepository = MockFavoritePostInDirectoryRepository()
    sut = DefaultFavoritePostInDirectoryUseCase(favoritePostInDirectoryRepository: mockRepository)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscription = nil
    expectation = nil
  }
}

/// 테스트 목적:
/// URLProtocl을 가로채 서버에서 데이터 받는 json key-value를 json file로 읽어들여 data로 반환합니다.
/// 반환한 데이터를  decoding해서 responseDTO로 변환 후 toDomain으로 entity로 변환받는 유즈케이스 테스트입니다.
extension FavoritePostInDirectoryUseCaseTests {
  func test_fetchFavoritePosts함수호출시_연관entity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.fetchFavoritePosts(name: "꿀맛탱음식점", page: 1, perPage: 5)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] postNestedCommentEntity in
        print("DEBUG: 값을 성공적으로 받았습니다.\n\n:\(postNestedCommentEntity)\n\n\n")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 3)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchFavoritePosts")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
  
  func test_toggleFavoritePost함수호출시_연관entity를받았는지_ShouldReturnTrue() {
    // Arrange
    var result = false
    var unexpectedError: Error?
    
    // Act
    subscription = sut.toggleFavoritePost(postId: 1, directoryName: "맛집폴더")
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] entity in
        print("DEBUG: 값을 성공적으로 받았습니다.\n\n:\(entity)\n\n\n")
        result = true
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 3)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "toggleFavoritePost")
    XCTAssertTrue(result, notReceivedErrorMessage)
  }
}
