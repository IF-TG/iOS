//
//  FirestoreUserProfileRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import XCTest
import Combine
@testable import SHFirestoreService
@testable import travelPlan

final class FirestoreUserProfileRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: UserProfileRepository!
  var expectation: XCTestExpectation!
  var subscriptions = Set<AnyCancellable>()
  let testPostId = "ABEB803F-DD54-41A4-B8BF-487A210BD1EC"
  let testCommentId = "12181109-6CDE-46E5-AD4F-04E824E89581"
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    
    sut = FirestoreUserProfileRepository(
      service: service,
      firebaseStorageService: FirebaseStorageService())
    
    expectation = XCTestExpectation(description: "Finish")
  }
  
  override func tearDown() {
    super.tearDown()
    expectation = nil
    subscriptions.removeAll()
  }
}

extension FirestoreUserProfileRepositoryTests {
  func test_fetchProfile호출시특정유저엔터티가받아지는지() {
    // Arrange
    var unexpectedError: Error?
    var receivedUser: UserEntity?
    let expectedUser = UserEntity(id: "sUSkn1ogJ5azdXaMYe0tt4sVJ8L2", nickname: "여행자", isSavedProfileInServer: false)
    
    // Act
    sut.fetchProfile(with: "sUSkn1ogJ5azdXaMYe0tt4sVJ8L2")
      .sink { completion in
        if case .failure(let error) = completion {
          unexpectedError = error
          self.expectation.fulfill()
        }
      } receiveValue: { userEntity in
        print("DEBUG: 값을 성공적으로 받았습니다: \(userEntity)")
        receivedUser = userEntity
        self.expectation.fulfill()
      }.store(in: &subscriptions)

    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "fetchProfileImageData")
    XCTAssertEqual(receivedUser, expectedUser, "특정 userId 호출시 예상하는 유저 엔터티와 같아야하지만 다른 값을 반환")
  }
}
