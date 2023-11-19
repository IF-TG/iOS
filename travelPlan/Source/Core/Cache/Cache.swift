//
//  Cache.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import Foundation

public final class Cache<Key: Hashable, Value> {
  // MARK: - Properties
  private let wrappedCache = NSCache<WrappedKey, Entry>()
  private let keyTracker = KeyTracker()
  private let dateProvider: () -> Date
  private let entryLifetime: TimeInterval
  
  // MARK: - Lifecycle
  init(
    dateProvider: @autoclosure @escaping () -> Date = Date.init(),
    entryLifetime: TimeInterval = 6 * 60 * 60,
    maximumEntryCount: Int = 100
  ) {
    self.dateProvider = dateProvider
    self.entryLifetime = entryLifetime
    wrappedCache.delegate = keyTracker
    wrappedCache.countLimit = maximumEntryCount
  }
}

// MARK: - Helpers
public extension Cache {
  func insert(_ value: Value, forKey key: Key) {
    let date = dateProvider().addingTimeInterval(entryLifetime)
    let entry = Entry(key: key, value: value, expirationDate: date)
    keyTracker.keys.insert(key)
    wrappedCache.setObject(entry, forKey: WrappedKey(key))
  }
  
  func value(forKey key: Key) -> Value? {
    guard
      let entry = wrappedCache.object(forKey: WrappedKey(key)) else {
      return nil
    }
    guard dateProvider() < entry.expirationDate else {
      removeValue(forKey: key)
      return nil
    }
    return entry.value
  }
  
  func removeValue(forKey key: Key) {
    wrappedCache.removeObject(forKey: WrappedKey(key))
  }
}

// MARK: - Private Helpers
private extension Cache {
  func entry(forKey key: Key) -> Entry? {
    guard let entry = wrappedCache.object(forKey: WrappedKey(key)) else {
      return nil
    }
    guard dateProvider() < entry.expirationDate else {
      removeValue(forKey: key)
      return nil
    }
    return entry
  }
  
  func insert(_ entry: Entry) {
    wrappedCache.setObject(entry, forKey: WrappedKey(entry.key))
    keyTracker.keys.insert(entry.key)
  }
}

// MARK: - Utils
public extension Cache {
  subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    } set {
      guard let value = newValue else {
        removeValue(forKey: key)
        return
      }
      insert(value, forKey: key)
    }
  }
}
