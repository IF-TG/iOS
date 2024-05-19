//
//  DefaultTourImageRetrieveInfoRepositoryTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/7/24.
//

import XCTest
import Combine
import Alamofire
@testable import travelPlan

final class DefaultTourImageRetrieveInfoRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: TourImageRetrieveInfoRepository!
  var subscriptions = Set<AnyCancellable>()
  var expectation: XCTestExpectation!
  let contentId = 1095732
  
  // MARK: - Lifecycle
  override func setUp() {
    super.setUp()
    let service = TourApiSessionProvider()
    let imageSession = {
      let sessionConfiguration = URLSessionConfiguration.default
      sessionConfiguration.timeoutIntervalForRequest = 10
      let monitor = ClosureEventMonitor()
      monitor.requestDidResume = { request in print("task 요청 시작!: \(request)") }
      monitor.requestDidFinish = { request in print("요청 끝: \(request)") }
      monitor.taskDidComplete = { _, _, error in
        if let error = error {
          print("Task completed with error: \(error)")
        } else {
          print("Task completed successfully")
        }
      }
      return Session(configuration: sessionConfiguration, eventMonitors: [monitor])
    }()
    sut = DefaultTourImageRetrieveInfoRepository(
      service: service,
      imageService: ImageSessionProvider(session: imageSession))
    expectation = XCTestExpectation(description: "테스트 시작!")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
    expectation = nil
  }
}

extension DefaultTourImageRetrieveInfoRepositoryTests {
  func test_retrieveAtomicImages호출시관련Entity를받는가() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    
    // Act
    let retrieveAtomicImagesPublisher = sut.retrieveAtomicImages(contentId: contentId, numOfRows: 10, pageNo: 1)
    sink(fromPublisher: retrieveAtomicImagesPublisher, withExpectation: expectation) { error, res in
      hasReceivedResult = res
      unexpectedError = error
    }.store(in: &self.subscriptions)
    
    wait(for: [expectation], timeout: 7.777)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "retrieveAtomicImages")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_retrieveImages호출시관련Entity를받는가() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    
    // Act
    let retrieveIamgesPublisher = sut.retrieveImages(contentId: contentId, numOfRows: 10, pageNo: 1)
    sink(fromPublisher: retrieveIamgesPublisher, withExpectation: expectation) { error, res in
      hasReceivedResult = res
      unexpectedError = error
    }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 50)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "retrieveImages")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
  
  func test_retrieveOriginalImages호출시_원본이미지데이터들관련Entity를받는가() {
    // Arrange
    var hasReceivedResult = false
    var unexpectedError: Error?
    
    // Act
    let sutPublisher = sut.retrieveOriginalImages(contentId: contentId, numOfRows: 10, pageNo: 1)
    sink(fromPublisher: sutPublisher, withExpectation: expectation) { error, res in
      hasReceivedResult = res
      unexpectedError = error
    }.store(in: &self.subscriptions)
    
    wait(for: [expectation], timeout: 50)
    
    // Assert
    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "retrieveOriginalImages")
    XCTAssert(hasReceivedResult, notReceivedErrorMessage)
  }
}
