//
//  NicknameValidationUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Combine
import Foundation

protocol NicknameValidationUseCase {
  func isNicknameDuplicated(with name: String) -> AnyPublisher<Bool, Error>
  func validateNickname(_ nickname: String) -> AnyPublisher<NicknameValidateState, Never>
}
