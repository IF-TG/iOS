//
//  Data+ImageIO.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import Foundation
import UIKit.UIImage
import ImageIO

extension Data {
  func convertToDownsampledImage(for size: CGSize) -> UIImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithData(self as CFData, options) else {
      return nil
    }
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: false,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceShouldCacheImmediately: false,
      kCGImageSourceThumbnailMaxPixelSize: Swift.max(size.width, size.height)
    ] as CFDictionary
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
      imageSource, 0, downsampleOptions
    ) else {
      return nil
    }
    return UIImage(cgImage: downsampledImage)
  }
}
