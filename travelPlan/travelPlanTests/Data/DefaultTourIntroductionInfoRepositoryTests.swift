//
//  DefaultTourIntroductionInfoRepositoryTests.swift
//  travelPlanTests
//
//  Created by SeokHyun on 5/8/24.
//

import XCTest
import Combine
@testable import travelPlan
final class DefaultTourIntroductionInfoRepositoryTests: XCTestCase {
  // MARK: - Properties
  var sut: DefaultTourIntroductionInfoRepository!
  var subscriptions: Set<AnyCancellable>!
  var expectation: XCTestExpectation!
  
  // MARK: - LifeCycle
  override func setUp() {
    super.setUp()
    sut = .init(service: SessionProvider())
    subscriptions = .init()
    expectation = .init(description: "비동기 호출 관리")
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    subscriptions.removeAll()
    expectation = nil
  }
}

extension DefaultTourIntroductionInfoRepositoryTests {
  func test_fetchFestival메소드_호출시_value로
}
