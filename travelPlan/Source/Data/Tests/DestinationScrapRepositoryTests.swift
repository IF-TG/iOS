//
//  DestinationScrapRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 7/12/24.
//

import XCTest
import Combine
import Foundation
@testable import travelPlan

final class DestinationScrapRepositoryTests: BaseXCTestCase {
  // MARK: - Properties
  private var sut: DestinationScrapRepository!

  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = JsonMockDestinationScrapRepository(backgroundQueue: .main)
    subscriptions = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  func test_getDestinationScrapList호출시_스크랩된여행지리스트가return되는지() {
    // Arrange
    let folderName = "전체"
    
    // Act
    let publisher = sut.getDestinationScrapList(folderName: folderName, page: nil, perPage: nil)
    
    _=execute(fromPublisher: publisher)
    wait(for: [expectation], timeout: 7.777)
    
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "getDestinationScrapList")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
    
  }
  
  func test_toggleDestinationScrap호출시_토글결과엔터티가return되는지() {
    // Arrange
    let scrapId: Int64 = 122
    let folderName = "전체"
    
    // Act
    let publisher = sut.toggleDestinationScrap(id: scrapId, folderName: folderName)
    
    _=execute(fromPublisher: publisher)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "toggleDestinationScrap")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_updateDestinationScrap호출시_업데이트된결과엔터티반환히는지() {
    // Arrange
    let idList: [Int64] = [1,2,3,4,5,6]
    let folderName = "전체"
    
    // Act
    let publisher = sut.updateDestinationScrap(objectIdList: idList, folderName: folderName)
    _=execute(fromPublisher: publisher)
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "updateDestinationScrap")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
