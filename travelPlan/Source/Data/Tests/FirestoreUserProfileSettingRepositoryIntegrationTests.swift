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
@testable import FirebaseFirestore

final class StubOwnerStorageForUserProfileSetting: OwnerStorage {
  var nickname: String? = "테스트유저"
  var profileImageData: Data?
  var isSavedProfileInServer: Bool = false
  var id: UserIdentifier? = 11
  var user: travelPlan.UserEntity? = .init(
    id: 11, nickname: "테스트유저", 
    profileImageUrl: "", isSavedProfileInServer: false)
  var blockedUsers: [UserIdentifier] = []
  func setUser(with userInfo: travelPlan.UserEntity) {}
  func addBlockedUser(with userId: UserIdentifier) {}
  func deleteBlockedUser(with userId: UserIdentifier) {}
  func hasBlockedUser(with userId: UserIdentifier) -> Bool { true }
  func updateNickname(with nickname: String) -> Bool { true }
  func updateProfileImagePath(with imagePath: String) -> Bool {
    print("프로필 이미지 경로 업데이트 됬습니다.")
    return true
  }
  func updateProfileImageData(with data: Data) -> Bool {
    print("프로필 이미지 데이터 업데이트 됬습니다.")
    return true
  }
  func deleteProfileImageData() -> Bool {
    print("프로필 이미지 데이터 삭제 됬습니다.")
    return true
  }
}

final class FirestoreUserProfileSettingRepositoryIntegrationTests: BaseXCTestCase {
  // MARK: - Properties
  var sut: UserProfileSettingRepository!
  let mockTestUserId: UserIdentifier = 11
  
  override func setUp() {
    super.setUp()
    let stubOwnerStorage = StubOwnerStorageForUserProfileSetting()
    let stubFirebaseStorage = StubFirebaseStorageService()
    let firebaseStorage = FirebaseStorageService()
    let firestoreService = FirestoreService()
    
    sut = FirestoreUserProfileSettingRepository(
      service: firestoreService,
      firebaseStorageService: firebaseStorage,
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
/// - Firbase firestore에는 이미지가 저장됬을떄 삭제하지않을 경우 이미지 식별이 불가능해 stub으로 이미지 service를 대체했습니다.
extension FirestoreUserProfileSettingRepositoryIntegrationTests {
  // MARK: - saveProfile tests
  func test_saveProfile호출시Storage에프로필이잘저장되는지와DB필드에Path가잘저장되는지_ShouldReturnTrue() {
    // Act
    let testPublisher = sut.saveProfile(
      with: mockTestUserId, nickname: "테스트여행유저", profileImageData: "프로필".data(using: .utf8))
    execute(fromPublisher: testPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    deleteTestUserDocument()
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "saveProfile")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_saveProfile호출시_DB필드에_이미지가없는경우Path가잘저장되는지_ShouldReturnTrue() {
    // Act
    let testPublisher = sut.saveProfile(with: 11, nickname: "테스트여행유저", profileImageData: nil)
    execute(fromPublisher: testPublisher).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    deleteTestUserDocument()
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "saveProfile")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  // MARK: - 사용자 이름 중복 테스트
  func test_checkIfUserNicknameDuplicate호출시_사용자가중복되어야함() {
    // Act
    sut
      .checkIfUserNicknameDuplicate(with: "테스트여행자")
      .sink { completion in
        // Assert
        if case .failure(let error) = completion {
          self.checkIfUnexpectedErrorOccurred(error, functionName: "checkIfUserNicknameDuplicate")
          self.expectation.fulfill()
        }
      } receiveValue: { isDuplicated in
        // Assert
        XCTAssert(isDuplicated, "테스트 결과 유저 닉네임이 중복되어야하는데, 중복되지 않음")
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
  }
  
  func test_checkIfUserNicknameDuplicate호출시_사용자이름이중복되면안됌() {
    // Act
    sut
      .checkIfUserNicknameDuplicate(with: "테스트여행자1111111111")
      .sink { completion in
        // Assert
        if case .failure(let error) = completion {
          self.checkIfUnexpectedErrorOccurred(error, functionName: "checkIfUserNicknameDuplicate")
          self.expectation.fulfill()
        }
      } receiveValue: { isDuplicated in
        // Assert
        XCTAssertFalse(isDuplicated, "테스트 결과 유저 닉네임이 중복되지 않아야하는데 중복됨")
        self.expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
  }
  
  // MARK: - 사용자 이름 업데이트 테스트
  func test_updateUserNickname호출시_디비에반영되는지() {
    // Act
    let testPublisher = sut.updateUserNickname(with: "테스트 여행자22")
    execute(fromPublisher: testPublisher).store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateUserNickname")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
    
    // Clean
    recoverUserName()
  }
  
  // MARK: - 사용자 프로필 이미지 관련 테스트
  /// stub storage를 바탕으로 테스트 진행합니다.
  /// 실제 storage service로는 테스트 진행시 저장, 삭제를 성공적으로 테스트했고, stub으로 교체했습니다.
  func test_saveProfileImage호출시_storage에저장되는지() {
    // Act
    let testPublihser = sut.saveProfileImage(with: "이미지".data(using: .utf8)!)
    execute(fromPublisher: testPublihser).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "saveProfileImage")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_deleteProfileImage호출시_storage에서삭제되는지() {
    // Act
    let testPublihser = sut.deleteProfileImage()
    execute(fromPublisher: testPublihser).store(in: &subscriptions)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "deleteProfileImage")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}

fileprivate extension FirestoreUserProfileSettingRepositoryIntegrationTests {
  func deleteTestUserDocument() {
    Firestore.firestore().collection("users").document(String(mockTestUserId)).delete { _ in }
  }
  
  
  func recoverUserName() {
    Firestore.firestore().collection("users")
      .document(String(mockTestUserId)).updateData(["nickname": "테스트여행자"]).sink { _ in
    } receiveValue: { _ in
    }.store(in: &subscriptions)
  }
}
