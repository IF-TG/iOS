//
//  UserEntity.swift
//  travelPlan
//
//  Created by 양승현 on 3/12/24.
//

import Foundation

struct UserEntity {
  let id: String
  var nickname: String
  var profileURL: String?
  /// 프로필을 변경하기 전에 최초 프로필이 저장되어 있는지 여부를 파악해야합니다.
  /// 프로필이 저장되어 있지 않은 경우 UserInfoUseCase -> saveProfile.
  /// 프로필이 최초 한번 서버에 저장된 이후 UserInfoUseCase -> updateProfile
  var isSavedProfile: Bool
}
