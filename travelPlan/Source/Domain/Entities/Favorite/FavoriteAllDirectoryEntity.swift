//
//  FavoriteAllDirectoryEntity.swift
//  travelPlan
//
//  Created by 양승현 on 7/17/24.
//

import RealmSwift
import Foundation

final class FavoriteAllDirectoryEntity: Object {
  @Persisted(primaryKey: true) var id: UUID = UUID()
  @Persisted var categoryCount: Int = 0
  @Persisted var imageData: List<Data>
}
