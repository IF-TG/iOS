//
//  OwnerError.swift
//  travelPlan
//
//  Created by 양승현 on 5/17/24.
//

import Foundation

/// 로그인한 사용자에 관련된 에러입니다.
@frozen enum OwnerError: LocalizedError {
  /// 로그인한 사용자는 로그인한 아이디가 있어야하는데 없다면 로그인 화면으로 나가서 다시 로그인하는 처리를 해야할것 같습니다.
  case invalidOwnerId
  /// 로그인한 사용자는 닉네임이 있어야하는데 없다면 로그인 화면으로 나가서 다시 로그인하는 처리를 해야할것 같습니다.
  case invalidOwnerNickname
}
