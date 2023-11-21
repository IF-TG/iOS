//
//  ImageIO.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import Foundation
import CoreGraphics.CGImage
import ImageIO

struct ImageIO {
  static func setDownsampled(atImageURL imageURL: URL, for size: CGSize) -> CGImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, options) else {
      return nil
    }
    
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: false,
      kCGImageSourceShouldCacheImmediately: false,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
    ] as CFDictionary
    
    return CGImageSourceCreateThumbnailAtIndex(
      imageSource,
      0,
      downsampleOptions)
  }
  
  static func setDwonsampled(atImageData imageData: Data, for size: CGSize) -> CGImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, options) else {
      return nil
    }
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: false,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceShouldCacheImmediately: false,
      kCGImageSourceThumbnailMaxPixelSize: Swift.max(size.width, size.height)
    ] as CFDictionary
    return CGImageSourceCreateThumbnailAtIndex(
      imageSource,
      0,
      downsampleOptions)
  }
  
  func imageDimension(url: String) -> CGSize? {
    guard let imageSource = CGImageSourceCreateWithURL(URL(string: url)! as CFURL, nil) else {
      return nil
    }
    guard let imageCopyProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
      return nil
    }
    let width = imageCopyProperties[kCGImagePropertyWidth] as? CGFloat ?? 50
    let height = imageCopyProperties[kCGImagePropertyHeight] as? CGFloat ?? 50
    return CGSize(width: width, height: height)
  }
}
