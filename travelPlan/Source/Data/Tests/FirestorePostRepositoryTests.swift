//
//  FirestorePostRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/2/24.
//

import XCTest
import Combine
import SHFirestoreService
@testable import travelPlan

class FirestorePostRepositoryTests: XCTestCase {
  var sut: PostRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    sut = FirestorePostRepository(
      service: FirestoreService(),
      firebaseStorageService: FiresabseStorageService(),
      profileRepository: MockMyProfileRepository())
    expectation = expectation(description: "테스트 시작!!")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    sut = nil
  }
}

extension FirestorePostRepositoryTests {
  func test_정상적으로fetchPosts호출할때_관련Entity를성공적으로얻어와야함() {
    // Arrange
    var unexpectedError: Error?
    var hasReceivedResult: Bool = false
    
    // Act
    sut.fetchPosts(page: 1, perPage: 5, category: .init(mainTheme: .all, orderBy: .newest))
      .sink { [unowned self] in
        if case .failure(let error) = $0 {
          unexpectedError = error
          expectation.fulfill()
        }
      } receiveValue: { [unowned self] page in
        print(page)
        hasReceivedResult = true
        expectation.fulfill()
      }.store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 15)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchPosts")
    XCTAssertTrue(hasReceivedResult, "fetchPosts호출시 entity를 받아야하지만 받지 못했습니다.")
  }
}
