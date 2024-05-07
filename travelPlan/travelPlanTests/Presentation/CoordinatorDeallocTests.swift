//
//  CoordinatorDeallocTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/4/24.
//

import XCTest
import UIKit
import SHCoordinator
@testable import travelPlan

final class CoordinatorDeallocTests: XCTestCase {
  
  var presenter: UINavigationController?
  
  override func setUp() {
    super.setUp()
    presenter = UINavigationController(rootViewController: UIViewController())
  }
  
  override func tearDown() {
    super.tearDown()
    presenter = nil
  }
}

// MARK: - CoordinatorDealloc test related Feed
extension CoordinatorDeallocTests {
  func test_PostDetailCoordinatorDealloc_ShouldReturnNil() {
    // Arrange
    let mockPostDetail = Post.Detail<[Post.PostContent]>(
      postID: "1", title: "", content: [], likes: 0, comments: 0,
      location: .init(x: 0, y: 0), createAt: Date(), tripDate: .init(startDate: Date(), endDate: Date()))
    let mockPostAuthor = Post.Author(profileImageData: nil, nickname: "")
    let mockCategory = Post.Category(themes: [], regions: [], seasons: [], partners: [])
    let mockPost = Post(
      liked: true, detail: mockPostDetail, author: mockPostAuthor,
      highResolveImages: [], category: mockCategory)
    
    
    // Act
    // Assert
    assertCoordinatorDeallocation {
      let postDetailCoordinator = PostDetailCoordinator(
        presenter: presenter,
        post: mockPost,
        category: mockCategory)
      return postDetailCoordinator
    }
  }
}
