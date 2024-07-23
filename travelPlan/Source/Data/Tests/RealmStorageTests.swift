////
////  RealmStorageTests.swift
////  travelPlanTests
////
////  Created by SeokHyun on 7/19/24.
////
//
//import XCTest
//import RealmSwift
//@testable import travelPlan
//
//final class RealmStorageTests: XCTestCase {
//  // MARK: - Properties
//  private var sut: RealmStorage!
//  private var testObject: TestObject!
//  
//  // MARK: - LifeCycle
//  override func setUp() {
//    super.setUp()
//    
//    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
//    sut = RealmStorage.shared
//    testObject = TestObject(name: "홍길동")
//  }
//  
//  override func tearDown() {
//    super.tearDown()
//    sut.delete(testObject)
//    sut = nil
//    testObject = nil
//  }
//}
//
//// MARK: - Tests
//extension RealmStorageTests {
//  func test_add시_return_true를_반환하는지() {
//    // Arrange
//    self.testObject = TestObject(name: "홍길동")
//    
//    // Act
//    let act = sut.add(testObject)
//    
//    // Assert
//    XCTAssertTrue(act, "act가 true를 반환해야 하는데, false 반환")
//  }
//  
//  func test_get시_요구한_객체를_반환하는지() {
//    // Arrange
//    self.testObject = TestObject(name: "홍길동")
//    var isObjectNotNil = true
//    
//    // Act
//    if let object = sut.get(primaryKey: testObject._id, type: TestObject.self) {
//      print(object)
//    } else {
//      isObjectNotNil = false
//    }
//    
//    // Assert
//    XCTAssertTrue(isObjectNotNil, "object를 성공적으로 받아오지 못했습니다.")
//  }
//}
//
//// MARK: - Nested
//private class TestObject: Object {
//  @Persisted(primaryKey: true) var _id: UUID
//  @Persisted var name: String
//  
//  convenience init(name: String) {
//    self.init()
//    self.name = name
//  }
//}
