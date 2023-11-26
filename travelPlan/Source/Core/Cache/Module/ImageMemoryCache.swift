//
//  ImageCache.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import UIKit

public final actor ImageMemoryCache {
  private let cache = Cache<String, UIImage>()
  private let imageConverter = ImageConverter()
}

// MARK: - ImageCachable
extension ImageMemoryCache: ImageMemoryCachable {
  func image(for url: String) -> UIImage? {
    guard let cached = cache[url] else {
      guard let image = imageConverter.base64ToImage(url) else {
        print("DEBUG: Image's Base64 형태가 잘못 되었습니다.")
        return nil
      }
      cache[url] = image
      return image
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
