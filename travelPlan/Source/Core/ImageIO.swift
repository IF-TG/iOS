//
//  ImageIO.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import Foundation
import CoreGraphics.CGImage
import ImageIO

public struct ImageIO {
  func setDownsampledCGImage(at createType: ImageSourceCreateType, for info: DownsampledOptions) -> CGImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = makeImageSource(at: createType, for: options) else {
      return nil
    }
    return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, info.rawValue)
  }
  
  func imageDimension(from createType: ImageSourceCreateType) -> CGSize? {
    guard let imageSource = makeImageSource(at: createType, for: nil) else {
      return nil
    }
    guard let imageCopyProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
      return nil
    }
    let width = imageCopyProperties[kCGImagePropertyWidth] as? CGFloat ?? 50
    let height = imageCopyProperties[kCGImagePropertyHeight] as? CGFloat ?? 50
    return CGSize(width: width, height: height)
  }
  
  private func makeImageSource(at createType: ImageSourceCreateType, for options: CFDictionary?) -> CGImageSource? {
    switch createType {
    case .url(let url):
      return CGImageSourceCreateWithURL(url as CFURL, options)
    case .data(let data):
      return CGImageSourceCreateWithData(data as CFData, options)
    }
  }
}
