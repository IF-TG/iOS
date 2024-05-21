//
//  UserNicknameSettingUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Combine
import Foundation

protocol UserNicknameSettingUseCase {
  func updateNickname(with name: String) -> AnyPublisher<Bool, Error>
}
