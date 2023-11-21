//
//  Cache+Nested.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import Foundation

internal extension Cache {
  final class WrappedKey: Equatable {
    let key: Key
    var hash: Int { return key.hashValue }
    
    init(_ key: Key) {
      self.key = key
    }
    
    func isEqual(_ object: Any?) -> Bool {
      guard let target = object as? WrappedKey else {
        return false
      }
      return target.key == key
    }
    
    static func == (lhs: Cache<Key, Value>.WrappedKey, rhs: Cache<Key, Value>.WrappedKey) -> Bool {
      return lhs.hash == rhs.hash
    }
  }
  
  final class Entry {
    let key: Key
    let value: Value
    let expirationDate: Date
    
    init(key: Key, value: Value, expirationDate: Date) {
      self.key = key
      self.value = value
      self.expirationDate = expirationDate
    }
  }
  
  final class KeyTracker: NSObject, NSCacheDelegate {
    var keys = Set<Key>()
    
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
      guard let entry = obj as? Entry else {
        return
      }
      keys.remove(entry.key)
    }
  }
  
  struct Configuration {
    let maximumCount: Int
    let memoryLimit: Int
    let entryLifetime: TimeInterval
    
    init(
      maximumCount: Int = 100,
      memoryLimit: Int = 1024 * 1024 * 300,
      entryLifetime: TimeInterval = 6 * 60 * 60
    ) {
      self.maximumCount = maximumCount
      self.memoryLimit = memoryLimit
      self.entryLifetime = entryLifetime
    }
  }

}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
