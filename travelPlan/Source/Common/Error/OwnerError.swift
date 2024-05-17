//
//  OwnerError.swift
//  travelPlan
//
//  Created by 양승현 on 5/17/24.
//

import Foundation

@frozen enum OwnerError: LocalizedError {
  /// 로그인한 사용자는 로그인한 아이디가 있어야하는데 없다면 로그인 화면으로 나가서 다시 로그인하는 처리를 해야할것 같습니다.
  case invalidOwnerId
}
