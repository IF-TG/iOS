//
//  Synchronized.swift
//  travelPlan
//
//  Created by 양승현 on 7/12/24.
//

import Foundation

/// lock, unlock매번 호출하지않게 하기위해: )
/// concurrent 환경에서 seri하게 수행할때 사용해요.
final class Synchronized {
  private let _lock = NSLock()
  
  /// 기본
  func sync(_ task: () -> Void) {
    lock()
    defer { unlock() }
    task()
  }
  
  /// 에러 발생할 수 있는 경우
  func sync(_ task: () throws -> Void) rethrows {
    lock()
    defer { unlock() }
    try task()
  }
  
  /// task후의 작업을 반환할 경우
  func sync<Result>(_ task: () -> Result) -> Result {
    lock()
    defer { unlock() }
    return task()
  }
  
  func sync<Result>(_ task: () throws -> Result) rethrows -> Result {
    lock()
    defer { unlock() }
    return try task()
  }
}

private extension Synchronized {
  @inline(__always)
  func lock() {
    _lock.lock()
  }
  
  @inline(__always)
  func unlock() {
    _lock.unlock()
  }
}
