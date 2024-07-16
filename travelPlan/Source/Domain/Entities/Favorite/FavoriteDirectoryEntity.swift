//
//  FavoriteDirectoryEntity.swift
//  travelPlan
//
//  Created by 양승현 on 7/16/24.
//

import RealmSwift
import Foundation

final class FavoriteDirectoryEntity: Object {
  /// PK
  /// 디렉터리 이름
  @Persisted var title: String
  
  /// 디렉터리의 대표 이미지
  @Persisted var imageThumbnails = List<Data>()
  
  /// 내부 디렉터리에서 보여질 수 잇는 데이터들의 id만 저장합니다.
  /// 이는 찜 바텀시트가 ui가 올라올 때 유용합니다. (이미 찜해져있는지 여부를 파악해야합니다.)
  @Persisted var postIdentifiers = List<PostIdentifier>()
  @Persisted var destinationIdentifiers = List<Int64>()
  
  /// 시간복잡도 O(1). 내부 포스트, 여행지 들의 총 개수를 반환합니다.
  var innerItemCount: Int {
    postIdentifiers.count + destinationIdentifiers.count
  }
  
  // MARK: - Lifecycle
  init(title: String) {
    self.title = title
  }
}
