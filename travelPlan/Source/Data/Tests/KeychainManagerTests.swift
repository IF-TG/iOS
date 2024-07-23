//
//  KeychainManagerTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 3/6/24.
//

import XCTest
@testable import travelPlan

final class KeychainManagerTests: XCTestCase {
  // MARK: - Properties
  var sut: KeychainManager!
  var key: String!
  var notRegistedKey: String!
  var data: Data!
  
  // MARK: - LifeCycle
  override func setUp() {
    sut = KeychainManager.shared
    key = UUID().uuidString
    notRegistedKey = UUID().uuidString
    data = "키체인_테스트_데이터".data(using: .utf8)
  }
  
  override func tearDown() {
    defer {
      key = nil
      notRegistedKey = nil
      sut = nil
      data = nil
    }
    
    sut.delete(key: key)
  }
}

// MARK: - TestCase

extension KeychainManagerTests {
  
  // MARK: - Create
  func testKeychainManager_키체인성공적으로추가되면_shouldReturnTrue() {
    // Arrange
    let key = self.key!
    let data = self.data
    
    // Act
    let result = sut.add(key: key, data: data)
    
    // Assert
    XCTAssertTrue(result)
  }
  
  func testKeychainManager_키체인add했는데_같은data로_또_add시_shouldReturnTrue() {
    // Arrange
    let key = self.key!
    let data = self.data
    sut.add(key: key, data: data)
    
    // Act
    let result = sut.add(key: key, data: data)
    
    // Assert
    XCTAssertTrue(result)
  }
  
  func testKeychainManager_키체인add했는데_다른data로_또_add시_shouldReturnTrue() {
    // Arrange
    let key = self.key!
    let data = self.data
    sut.add(key: key, data: data)
    
    // Act
    let newData = "새로운데이터".data(using: .utf8)
    let result = sut.add(key: key, data: newData)
    
    // Assert
    XCTAssertTrue(result)
  }
  
  // MARK: - Read
  func testKeychainManager_키체인성공적으로로드되면_shouldReturnOptionalData() {
    // Arrange
    let key = self.key!
    let data = self.data
    sut.add(key: key, data: data)
    
    // Act
    let result = sut.load(key: key)
    
    // Assert
    XCTAssertEqual(result, data)
  }
  
  func testKeychainManager_키체인key없는데_load메소드호출하면_shouldReturnNil() {
    // Arrange
    let data = self.data
    let notRegistedKey = self.notRegistedKey!
    
    // Act
    let result = sut.load(key: notRegistedKey)
    
    // Assert
    XCTAssertNil(result)
  }
  
  // MARK: - Update
  func testKeychainManager_키체인성공적으로업데이트되면_shouldReturnTrue() {
    // Arrange
    let key = self.key!
    let data = self.data
    sut.add(key: key, data: data)
    
    // Act
    let updateData = "키체인_업데이트_데이터".data(using: .utf8)!
    let result = sut.update(key: key, data: updateData)
    
    // Assert
    XCTAssertTrue(result)
  }
  
  func testKeychainManager_등록된키가없는데_업데이트하면_shouldReturnFalse() {
    // Arrange
    let notRegistedKey = self.notRegistedKey!
    let data = self.data
    
    // Act
    let result = sut.update(key: notRegistedKey, data: data)
    
    // Assert
    XCTAssertFalse(result)
  }
  
  func testKeychainManager_동일한_데이터로_update하면_shouldReturnFalse() {
    // Arrange
    let key = self.key!
    let data = self.data
    
    // Act
    sut.update(key: key, data: data)
    let result = sut.update(key: key, data: data)
    
    // Assert
    XCTAssertFalse(result)
  }
  
  // MARK: - Delete
  func testKeychainManager_키체인성공적으로삭제되면_shouldReturnTrue() {
    // Arrange
    let key = self.key!
    let data = self.data
    sut.add(key: key, data: data)
    
    // Act
    let result = sut.delete(key: key)
    
    // Assert
    XCTAssertTrue(result)
  }
  
  func testKeychainManager_등록되어있지않은키를_delete_하면_shouldReturnFalse() {
    // Arrange
    let notRegistedKey = self.notRegistedKey!
    
    // Act
    let result = sut.delete(key: notRegistedKey)
    
    // Assert
    XCTAssertFalse(result)
  }
}
