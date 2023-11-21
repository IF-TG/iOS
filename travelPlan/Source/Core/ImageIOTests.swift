//
//  ImageIOTests.swift
//  travelPlanTests
//
//  Created by 양승현 on 11/22/23.
//

import XCTest
@testable import travelPlan

final class ImageIOTests: XCTestCase {
  let sut = ImageIO()
}

extension ImageIOTests {
  func testImageIO_CompareDownsampledImageWithOriginalImageWhenUsingSetDownsampleFunc_shouldLessthanOrignal() {
    // Arrange
    let originalImage = UIImage(named: "tempThumbnail1")!
    let originalImageData = originalImage.pngData()!
    let targetResizedSize = CGSize(width: 35, height: 35)
    let downsampledOptions = ImageIO.DownsampledOptions.init(imagePixelSize: targetResizedSize)
    let imageSourceCreateType: ImageIO.ImageSourceCreateType = .data(originalImageData)
    
    // Act
    let cgImage = sut.setDownsampledCGImage(at: imageSourceCreateType, for: downsampledOptions)
    
    // Assert
    XCTAssertNotNil(cgImage, "다운샘플링된 이미지가 nil이 되면 안되는데 nil이 반환됨.")
    let downsampledData = UIImage(cgImage: cgImage!).pngData()!
    XCTAssertLessThan(downsampledData.count, originalImageData.count, "다운 샘플링된 이미지가 원본 UIImage 데이터보다 작아야함")
    debugPrint("원래 image bytes: ", originalImageData)
    debugPrint("다운 샘플링된 image bytes ", downsampledData)
  }
  
  func testImageIO_ImageDimension_ShouldReturnEqual() {
    // Arrange
    let originalImage = UIImage(named: "tempThumbnail1")
    
    // Act
    
    
    // Assert
    XCTAssertFalse(true)
  }
}
