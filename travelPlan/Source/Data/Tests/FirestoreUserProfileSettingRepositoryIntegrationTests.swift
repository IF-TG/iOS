//
//  FirestoreUserProfileSettingRepositoryIntegrationTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/20/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

struct StubOwnerStorageForUserProfileSetting: OwnerStorage {
  var nickname: String? = "테스트유저"
  var profileImageData: Data?
  var isSavedProfileInServer: Bool = false
  var id: String? = "testUser1"
  var user: travelPlan.UserEntity? = .init(id: "testUser1", nickname: "테스트유저", profileImageUrl: "", isSavedProfileInServer: false)
  var blockedUsers: [BlockedUserId]
  func setUser(with userInfo: travelPlan.UserEntity) {}
  func addBlockedUser(with userId: BlockedUserId) {}
  func deleteBlockedUser(with userId: BlockedUserId) {}
  func hasBlockedUser(with userId: BlockedUserId) -> Bool { true }
  func updateNickname(with nickname: String) -> Bool { true }
  func updateProfileImagePath(with imagePath: String) -> Bool { true }
  func updateProfileImageData(with data: Data) -> Bool { true }
  func deleteProfileImageData() -> Bool { true }
}

final class FirestoreUserProfileSettingRepositoryIntegrationTests: BaseXCTestCase {
  // MARK: - Properties
  var sut: UserProfileSettingRepository!
  
  override func setUp() {
    super.setUp()
    let service = FirestoreService()
    let stubOwnerStorage = StubOwnerStorage()
    let firebaseStoraged = FirebaseStorageService()
    let firestoreService = FirestoreService()
    
    sut = FirestoreUserProfileSettingRepository(
      service: firestoreService,
      firebaseStorageService: firebaseStoraged,
      ownerStorage: stubOwnerStorage)
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
}

/// FirestoreService를 보면서 테스트를 실행해야 합니다.
/// 테스트는 다음과 같습니다.
/// - 실제 Firebase firestore 및 Firebase Storage에 접근합니다.
/// - sut의 함수 호출시 로직을 수행하고 에러가 없이 결과를 받는 경우를 위해 테스트 및 sut의 로직 구현을 합니다.
extension FirestoreUserProfileSettingRepositoryIntegrationTests {
  func test_saveProfile호출시Storage에프로필이잘저장되는지와DB필드에Path가잘저장되는지_ShouldReturnTrue() {
    // Act
    let testPublisher = sut.saveProfile(with: "testUser11", nickname: "테스트여행유저", profileImageData: "프로필".data(using: .utf8))
    execute(fromPublisher: testPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "saveProfile")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
