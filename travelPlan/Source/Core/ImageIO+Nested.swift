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
    
    var hasThumbnailAlwaysCreate: Bool = false
    var shouldCacheImmediately: Bool = false
    var hasTransformWhenCreate: Bool = true
    var imagePixelSize: CGSize?
    
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
