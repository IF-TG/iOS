//
//  UIImage+ImageIO.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit
import ImageIO

extension UIImage {
  func setDowndampled(at imageURL: URL, for size: CGSize) -> UIImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, options) else {
      return nil
    }
    
    let downSampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: false,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
    ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
      imageSource,
      0,
      downSampleOptions
    ) else {
      return nil
    }
    return UIImage(cgImage: downsampledImage)
  }
}
