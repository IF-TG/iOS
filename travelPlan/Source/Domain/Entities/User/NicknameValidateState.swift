//
//  NicknameValidateState.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Foundation

@frozen enum NicknameValidateState {
  /// 기존 사용자 닉네임
  case `default`
  /// 새로운 닉네임 변환 가능
  case available
  /// 중복
  case duplicated
  /// 입력된 길이 초과
  case overflow
  /// 더 입력해야합니다.
  case underflow
}
