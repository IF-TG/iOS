//
//  UserInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

/// 사용자 정보 CRUD 관련 레포지토리
protocol UserInfoRepository {
  func checkIfUserNicknameDuplicate(with name: String) -> Future<Bool, MainError>
  func updateUserNickname(with name: String) -> Future<Bool, MainError>
  func updateProfile(with profile: String) -> Future<Bool, MainError>
  func saveProfile(with profile: String) -> Future<Bool, MainError>
  func deleteProfile() -> Future<Bool, MainError>
  func fetchProfile() -> Future<ProfileImageEntity, MainError>
}
