//
//  StubUserNicknameSettingUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 8/17/24.
//

import Combine
import Foundation

final class StubUserNicknameSettingUseCase: UserNicknameSettingUseCase {
  func updateNickname(with name: String) -> AnyPublisher<Bool, any Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
}
