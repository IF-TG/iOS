//
//  DefaultNicknameValidationUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/19/24.
//

import Combine
import Foundation

final class DefaultNicknameValidationUseCase {
  // MARK: - Dependencies
  private let userProfileSettingRepository: UserProfileSettingRepository
  
  private let ownerStorage: OwnerStorage
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    userProfileSettingRepository: UserProfileSettingRepository,
    ownerStorage: OwnerStorage
  ) {
    self.userProfileSettingRepository = userProfileSettingRepository
    self.ownerStorage = ownerStorage
  }
}

// MARK: - NicknameValidationUseCase
extension DefaultNicknameValidationUseCase: NicknameValidationUseCase {
  func isNicknameDuplicated(with name: String) -> AnyPublisher<Bool, any Error> {
    userProfileSettingRepository.checkIfUserNicknameDuplicate(with: name)
  }
  
  func validateNickname(
    _ nickname: String
  ) -> AnyPublisher<NicknameValidateState, any Error> {
    let nicknameCount = nickname.count
    let isWithinValidLength = (nicknameMinLength...nicknameMaxLength).contains(nicknameCount)
    let isBelowMinLength = (0..<nicknameMinLength).contains(nicknameCount) || nickname.isEmpty
    let isAboveMaxLength = nicknameCount > nicknameMaxLength
    
    return Future { [weak self] promise in
      guard let ownerNickname = self?.ownerStorage.nickname else {
        promise(.failure(OwnerError.invalidOwnerNickname))
        return
      }
      
      if isBelowMinLength {
        promise(.success(.underflow))
      } else if isAboveMaxLength {
        promise(.success(.overflow))
      } else if isWithinValidLength {
        if ownerNickname == nickname {
          promise(.success(.default))
          return
        }
        self?.isNicknameDuplicated(with: nickname, promise: promise)
      }
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension DefaultNicknameValidationUseCase {
  func isNicknameDuplicated(
    with nickname: String,
    promise: @escaping Future<NicknameValidateState, Error>.Promise
  ) {
    let subscription = isNicknameDuplicated(with: nickname)
      .sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { isDuplicated in
        promise(.success(isDuplicated ? .duplicated : .available))
      }
    subscriptions.insert(subscription)
  }
}
