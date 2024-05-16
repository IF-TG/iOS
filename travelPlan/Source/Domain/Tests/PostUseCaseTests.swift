//
//  PostUseCaseTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 3/8/24.
//

import XCTest
import Combine
@testable import travelPlan

// FIXME: - 이거 4개 분리된 유즈케이스로 나누어야합니다
//final class PostUseCaseTests: XCTestCase {
//  // MARK: - Properties
//  var sut: PostUseCase!
//  var mockRepository: PostRepository!
//  var subscription: AnyCancellable?
//  var expectation: XCTestExpectation!
//  
//  // MARK: - Lifecycle
//  override func setUp() {
//    super.setUp()
//    mockRepository = MockPostRepository()
//    sut = DefaultPostUseCase(postRepository: mockRepository)
//    expectation = XCTestExpectation(description: "Finish")
//  }
//  
//  override func tearDown() {
//    super.tearDown()
//    sut = nil
//    subscription = nil
//    expectation = nil
//  }
//}
//// MARK: - PostUseCase.fetchPosts Tests
//extension PostUseCaseTests {
//  func testPostUseCase_fetchPosts함수를통해_postContainer배열값을_받았는지_responseDTO검증_shouldReturnTrue() {
//    // Arrange
//    let mockCategory = PostCategory(mainTheme: .all, orderBy: .newest)
//    let mockPostFetchRequestValue = PostFetchRequestValue(page: 0, perPage: 10, category: mockCategory)
//    var result: Bool = false
//    var unexpectedError: Error?
//    
//    // Act
//    subscription = sut.fetchPosts(with: mockPostFetchRequestValue).sink(receiveCompletion: { completion in
//      if case .failure(let error) = completion {
//        unexpectedError = error
//        result = false
//        self.expectation.fulfill()
//      }
//    }, receiveValue: { postsPage in
//      print("DEBUG: 값을 성공적으로 받음\n\(postsPage.posts.description)")
//      result = true
//      self.expectation.fulfill()
//    })
//    
//    wait(for: [expectation], timeout: 7)
//    
//    // Assert
//    if let unexpectedError {
//      XCTAssert(
//        false,
//        """
//          testPostUseCase의 fetchPosts()를 호출했을 때 postContainer값을 성공적으로 받아야 하지만 에러가 발생됨
//          Error description:\(unexpectedError.localizedDescription)
//        """)
//    }
//    
//    XCTAssertTrue(
//      result,
//      "testPostUseCase의 fetchPosts()를 호출했을 때 postContainer값을 받아야하지만, 퍼블리셔의 upstream이 종료됨")
//  }
//}
//
//// MARK: - PostUseCase.fetchComments()
//extension PostUseCaseTests {
//  func testPostUseCase_fetchComments함수를통해_mockJson을디코딩해_PostCommentContainer를_받는경우_ShouldReturnTrue() {
//    // Arrange
//    let mockReqeustValue = PostCommentsRequestValue(page: 1, perPage: 5, postId: "1")
//    var result = false
//    var unexpectedError: Error?
//    
//    // Act
//    subscription = sut.fetchComments(with: mockReqeustValue)
//      .sink(receiveCompletion: { [unowned self] completion in
//        if case .failure(let error) = completion {
//          unexpectedError = error
//          expectation.fulfill()
//        }
//        result = true
//        expectation.fulfill()
//      }, receiveValue: { [unowned self] postCommentContainerEntity in
//        NSLog("DEBUG: \(postCommentContainerEntity.comments.description)")
//        result = true
//        expectation.fulfill()
//      })
//   wait(for: [expectation], timeout: 7)
//    
//    // Assert
//    if let unexpectedError {
//      XCTAssert(
//        false,
//        """
//          PostUseCase의 fetchComments()를 호출했을 때 postCommentContainerEntity값을 성공적으로 받아야 하지만 에러 발생됨
//          Error description:\(unexpectedError.localizedDescription)
//        """)
//    }
//    
//    XCTAssertTrue(
//      result,
//      "PostUseCase의 fetchComments()를 호출했을 때 postCommentContainerEntity값을 받아야하지만, 퍼블리셔의 upstream이 종료됨")
//  }
//}
//
//
//// MARK: - PostUseCase.fetchLikedPostsByLoggedInUser Tests
//extension PostUseCaseTests {
//  func testPostUseCase_fetchLikedPostsByLoggedInUser함수를통해_postContainer배열값을_받았는지_responseDTO검증_shouldReturnTrue() {
//    // Arrange
//    var result: Bool = false
//    var unexpectedError: Error?
//    
//    // Act
//    subscription = sut.fetchLikedPostsByLoggedInUser(
//      page: 1,
//      perPage: 5
//    ).sink { completion in
//      if case .failure(let error) = completion {
//        unexpectedError = error
//        result = false
//        self.expectation.fulfill()
//      }
//    } receiveValue: { postsPage in
//      print("DEBUG: 값을 성공적으로 받음\n\(postsPage.posts.description)")
//      result = true
//      self.expectation.fulfill()
//    }
//    
//    wait(for: [expectation], timeout: 7)
//    
//    // Assert
//    if let unexpectedError {
//      XCTAssert(
//        false,
//        """
//          testPostUseCase의 fetchPosts()를 호출했을 때 postContainer값을 성공적으로 받아야 하지만 에러가 발생됨
//          Error description:\(unexpectedError.localizedDescription)
//        """)
//    }
//    
//    XCTAssertTrue(
//      result,
//      "testPostUseCase의 fetchPosts()를 호출했을 때 postContainer값을 받아야하지만, 퍼블리셔의 upstream이 종료됨")
//  }
//  
//  func test_searchPosts함수호출시_OutputValue로Entity받았는지_ShouldReturnTrue() {
//    // Arrange
//    var result = false
//    var unexpectedError: Error?
//    
//    // Act
//    subscription = sut.searchPosts(keyword: "가장 맛있는 국밥집", page: 1, perPage: 10, isTitle: false, isContent: true)
//      .sink { [unowned self] completion in
//        if case .failure(let error) = completion {
//          unexpectedError = error
//        }
//        expectation.fulfill()
//      } receiveValue: { [unowned self] entity in
//        print("DEBUG: 값을 성공적으로 받았습니다~\n\n:\(entity)")
//        result = true
//        expectation.fulfill()
//      }
//    wait(for: [expectation], timeout: 7.777777777)
//    
//    // Assert
//    checkIfUnexpectedErrorOccurred(unexpectedError, functionName: "searchPosts")
//    XCTAssertTrue(result, notReceivedErrorMessage)
//  }
//
//}
