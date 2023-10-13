//
//  Encodable+.swift
//  travelPlan
//
//  Created by 양승현 on 10/14/23.
//

import Foundation

extension Encodable {
  var toDictionary: [String: Any]? {
    guard let jsonData = try? JSONEncoder().encode(self) else { return  nil }
    return try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
  }
}
