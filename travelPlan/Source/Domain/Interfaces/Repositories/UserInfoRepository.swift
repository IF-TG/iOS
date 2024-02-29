//
//  UserInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

/// 사용자 정보 CRUD 관련 레포지토리
protocol UserInfoRepository {
  func isDuplicatedName(with name: String) -> Future<Bool, Never> 
  func updateUserNickname(with name: String) -> Future<Bool, MainError>
}
