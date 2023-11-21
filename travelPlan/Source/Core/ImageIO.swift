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
  func setDownsampled(atImageURL imageURL: URL, for info: DownsampledOptions) -> CGImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, options) else {
      return nil
    }
    return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, info.rawValue)
  }
  
  func setDwonsampled(atImageData imageData: Data, for info: DownsampledOptions) -> CGImage? {
    let options = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, options) else {
      return nil
    }
    return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, info.rawValue)
  }
  
  func imageDimension(from url: String) -> CGSize? {
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
  
  private func makeImageSource(at createType: ImageSourceCreateType, for info: DownsampledOptions?) -> CGImageSource? {
    switch createType {
    case .url(let url):
      return CGImageSourceCreateWithURL(url as CFURL, info?.rawValue)
    case .data(let data):
      return CGImageSourceCreateWithData(data as CFData, info?.rawValue)
    }
  }
}
