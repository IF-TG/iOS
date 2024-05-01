//
//  FirestorePostHeartRepositoryTests.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation

import XCTest
import Combine
import SHFirestoreService
@testable import travelPlan

final class FirestorePostHeartRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: PostHeartRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    sut = FirestorePostHeartRepository(service: service)
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestorePostHeartRepositoryTests {
  func test_UserHearts컬랙션이없을때FetchHeartUsers호출시_빈문자열을반환해야함() {
    // Arrange
    let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
    var unexpectedError: Error?
    var usersID: [String] = []
    
    // Act
    sut.fetchHeartUsers(testPostId)
      .sink { [unowned self] completion in
        if case .failure(let error) = completion {
          unexpectedError = error
        }
        expectation.fulfill()
      } receiveValue: { [unowned self] result in
        usersID = result
        expectation.fulfill()
      }.store(in: &subscriptions)

    wait(for: [expectation], timeout: 10)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchHeartUsers")
    XCTAssertEqual(usersID.count, 0, "테스트 포스트ID의 user-hearts컬랙션이 없을때 빈 문자열을 반환해야하지만 예상치 못한 값을 받게됨.")
  }
}
