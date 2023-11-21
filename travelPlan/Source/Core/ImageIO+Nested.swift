//
//  ImageIO+Nested.swift
//  travelPlan
//
//  Created by 양승현 on 11/22/23.
//

import Foundation
import ImageIO

public extension ImageIO {
  struct DownsampledOptions: RawRepresentable {
    public typealias RawValue = CFDictionary
    
    let hasThumbnailAlwaysCreate: Bool
    let shouldCacheImmediately: Bool
    let hasTransformWhenCreate: Bool
    let imagePixelSize: CGSize?
    
    init(
      hasThumbnailAlwaysCreate: Bool = false,
      shouldCacheImmediately: Bool = false,
      hasTransformWhenCreate: Bool = true,
      imagePixelSize: CGSize?
    ) {
      self.hasThumbnailAlwaysCreate = hasThumbnailAlwaysCreate
      self.shouldCacheImmediately = shouldCacheImmediately
      self.hasTransformWhenCreate = hasTransformWhenCreate
      self.imagePixelSize = imagePixelSize
    }
    
    public init?(rawValue: RawValue) {
      nil
    }
    
    public var rawValue: RawValue {
      var options: [CFString: Any] = [:]
      options[kCGImageSourceCreateThumbnailFromImageAlways] = hasThumbnailAlwaysCreate
      options[kCGImageSourceCreateThumbnailWithTransform] = hasTransformWhenCreate
      options[kCGImageSourceShouldCacheImmediately] = shouldCacheImmediately
      if let imagePixelSize {
        options[kCGImageSourceThumbnailMaxPixelSize] = Swift.max(imagePixelSize.width, imagePixelSize.height)
      }
      return options as CFDictionary
    }
  }
}
