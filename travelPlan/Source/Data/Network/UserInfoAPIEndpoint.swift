//
//  UserInfoAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation

struct UserInfoAPIEndpoint {
  private init() {}
  static let `default` = UserInfoAPIEndpoint()
  
  /// 사용자의 이름이 중복인지 확인할 때 사용합니다.
  func isDuplicatedNickname(
    with requestDTO: UserNicknameRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint<CommonDTO<Bool>>(
      scheme: "http://localhost:8080",method: .get,
      parameters: requestDTO,
      requestType: .userNameDuplicateCheck)
  }
}
