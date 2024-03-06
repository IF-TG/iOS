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
  var value: Data!
  // MARK: - LifeCycle
  override func setUp() {
    sut = KeychainManager.shared
    key = "키체인테스트키"
    value = "데이터".data(using: .utf8)
  }
  
  override func tearDown() {
    print(sut.delete(key: key))
    sut = nil
    key = nil
    value = nil
  }
}

extension KeychainManagerTests {
  func testKeychainManager_키체인성공적으로추가되면_shouldReturnTrue() {
    XCTAssertTrue(sut.add(key: key, value: value))
    sut.delete(key: key)
  }
  
  func testKeychainManager_키체인성공적으로삭제되면_shouldReturnTrue() {
    sut.add(key: key, value: value)
    XCTAssertTrue(sut.delete(key: key))
  }
  
  func testKeychainManager_키체인성공적으로업데이트되면_shouldReturnTrue() {
    sut.add(key: key, value: value)
    let updateValue = "업데이트value".data(using: .utf8)!
    XCTAssertTrue(sut.update(key: key, value: updateValue))
    sut.delete(key: key)
  }
  
  func testKeychainManager_키체인성공적으로로드되면_shouldReturnTrue() {
    sut.add(key: key, value: value)
    if let loadedValue = sut.load(key: key) {
      XCTAssertEqual(value, loadedValue)
    }
    sut.delete(key: key)
  }
}
