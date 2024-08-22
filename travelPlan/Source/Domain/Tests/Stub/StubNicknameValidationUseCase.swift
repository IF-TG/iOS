//
//  StubNicknameValidationUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 8/17/24.
//

import Combine
import Foundation

struct StubNicknameValidationUseCase: NicknameValidationUseCase {
  func isNicknameDuplicated(with name: String) -> AnyPublisher<Bool, any Error> {
    return Just(false).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func validateNickname(_ nickname: String) -> AnyPublisher<NicknameValidateState, any Error> {
    var state: NicknameValidateState!
    let cnt = nickname.count
    if (3...15)~=cnt {
      state = .available
    } else if (0...2)~=cnt {
      state = .underflow
    } else if cnt>15 {
      state = .overflow
    } else if nickname == "난짱구" {
      state = .default
    }
    return Just(state).setAnyErrorAndEraseToAnyPublisher()
  }
}
