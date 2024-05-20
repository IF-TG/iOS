//
//  FirestoreUserProfileSettingRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/20/24.
//

import XCTest
import Combine
@testable import travelPlan
@testable import SHFirestoreService

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

/// FirestoreService를 보면서 테스트를 실행해야 합니다..
extension FirestoreUserProfileSettingRepositoryIntegrationTests {
  func test_saveProfile호출시프로필
}
