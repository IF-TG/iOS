//
//  ImageDiskCacheTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 11/21/23.
//

import XCTest
@testable import travelPlan

final class ImageDiskCacheTests: XCTestCase {
  var sut: ImageDiskCache!
  
  override func setUp() {
    super.setUp()
    sut = ImageDiskCache()
  }
  
  override func tearDown() {
    super.tearDown()
    sut.removeAllImages()
    sut = nil
  }
}

// MARK: - Test
extension ImageDiskCacheTests {
  /// 이미지를 저장할 파일 경로를 base64로 인코딩해서 저장하려고하면.. "/" 이런 경로가 들어가는데, 이때 파일경로로 인식될수있고 너무길어서 파일로 write가 안됩니다.
  /// 굳이라는 생각도있고.. 그런데 서버에서 받아올땐 base64여서 우선 hashValue로 저장하고 꺼내오도록 실험했습니다.
  func testImageDiskCache_save로이미지저장할경우_ShouldReturnTrue() {
    // Arrange
    let image = UIImage(named: "tempProfile1")!
    let URLPath = "\(image.base64!.hashValue)"

    // Act
    sut.save(image, with: URLPath)
    let filePath = sut.imageFileURL(for: URLPath)?.path
    let res = sut.hasExistFile(atKey: URLPath)
    
    // Assert
    XCTAssertNotNil(filePath, "이미지 파일 경로 nil")
    XCTAssertTrue(res, "파일이 존재하지 않습니다.")
  }
}
