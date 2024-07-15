//
//  UpdatedPostHeartInfo.swift
//  travelPlan
//
//  Created by 양승현 on 7/14/24.
//

import Foundation

struct UpdatedPostHeartInfo {
  let indexPath: IndexPath
  let numberOfHearts: Int32
  
  /// 포스트 상세 화면에서 포스트가 변경된 경우 hasHeartPost 프로퍼티가 사용됩니다.
  /// 피드 화면에서 하트를 누를 경우, 자동으로 애니메이션이 동작되며 ui 상태가 변경되기에 사용하지 않습니다.
  let hasHeartPost: Bool?
}
