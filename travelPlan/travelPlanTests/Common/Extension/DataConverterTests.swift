//
//  DataConverterTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 3/15/24.
//

import XCTest
@testable import travelPlan

final class DataConverterTests: XCTestCase { }

// MARK: - TestCase
extension DataConverterTests {
  
  // MARK: - Double <-> Data
  func testDataConverter_Double값을_Data로_변환성공시shouldReturnTrue() {
    // Arrange
    let doubleValue: Double = 3.14
    
    // Act
    let convertedToData = doubleValue.toData()
    
    // Assert
    XCTAssertTrue(type(of: convertedToData) == Data.self)
  }
  
  func testDataConverter_DataMadeOfDouble을_다시_기존의_값이었던_Double로_복원_성공하면shouldReturnTrue() {
    // Assert
    let doubleValue: Double = 3.14
    let convertedToData = doubleValue.toData()
    
    // Act
    let restored = convertedToData.toDouble()!
    
    // Assert
    XCTAssertTrue(doubleValue == restored)
  }
  
  // MARK: - Int <-> Data
  func testDataConverter_Int값을_Data로_변환성공시shouldReturnTrue() {
    // Arrange
    let intValue: Int = 314
    
    // Act
    let convertedToData = intValue.toData()
    
    // Assert
    XCTAssertTrue(type(of: convertedToData) == Data.self)
  }
  
  func testDataConverter_DataMadeOfInt을_다시_기존의_값이었던_Int로_복원_성공하면shouldReturnTrue() {
    // Assert
    let intValue: Int = 314
    let convertedToData = intValue.toData()
    
    // Act
    let restored = convertedToData.toInt()!
    
    // Assert
    XCTAssertTrue(intValue == restored)
  }
}
