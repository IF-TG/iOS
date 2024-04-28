//
//  ImageCache.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import Foundation

public final class ImageMemoryCache {
  private let cache = Cache<String, Data>()
  private let lock = NSLock()
}

// MARK: - ImageCachable
extension ImageMemoryCache: ImageMemoryCachable {
  public func imageData(for url: String) -> Data? {
    lock.lock()
    defer { lock.unlock() }
    return cache[url]
  }
  
  public func insert(_ imageData: Data, forKey url: String) {
    lock.lock()
    defer { lock.unlock() }
    cache.insert(imageData, forKey: url)
  }
  
  public func removeImageData(for url: String) {
    cache[url] = nil
  }

  public func removeAllImages() {
    cache.removeAll()
  }
  
  public subscript(url: String) -> Data? {
    get {
      return imageData(for: url)
    }
    set {
      guard let newValue else {
        removeImageData(for: url)
        return
      }
      insert(newValue, forKey: url)
    }
  }
}
