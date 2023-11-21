//
//  UIImage+ImageIO.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import UIKit
import ImageIO

extension UIImage {
  func setDownsampled(at imageURL: URL, for size: CGSize) -> UIImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, options) else {
      return nil
    }
    
    let downsampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: false,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
    ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
      imageSource,
      0,
      downsampleOptions
    ) else {
      return nil
    }
    return UIImage(cgImage: downsampledImage)
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
