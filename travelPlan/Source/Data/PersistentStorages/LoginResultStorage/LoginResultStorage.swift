//
//  LoginResultStorage.swift
//  travelPlan
//
//  Created by SeokHyun on 3/14/24.
//

import Foundation

protocol LoginResultStorage {
  @discardableResult
  func save(forResult result: Bool) -> Bool
}
