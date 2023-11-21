//
//  ImageCache.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import UIKit

final actor ImageMemoryCache {
  private let cache = Cache<String, UIImage>()
  private let imageConverter = ImageConverter()
}

// MARK: - ImageCachable
extension ImageMemoryCache: ImageCachable {
  func image(for url: String) -> UIImage? {
    guard let cached = cache[url] else {
      return nil
    }
    return cached
  }
  
  func insert(_ image: UIImage, forKey url: String) {
    cache[url] = image
  }
  
  func removeImage(for url: String) {
    cache[url] = nil
  }
  
  nonisolated func removeAllImages() {
    cache.removeAll()
  }
  
  subscript(url: String) -> UIImage? {
    get {
      return image(for: url)
    }
    set {
      guard let newValue else {
        removeImage(for: url)
        return
      }
      insert(newValue, forKey: url)
    }
  }
}
