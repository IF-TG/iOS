//
//  MyInformationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Foundation
import Combine

final class MyInformationViewModel {
  struct Input {
    struct UserEditableElement {
      let nickname: String?
      let profileImage: String?
    }
    let isNicknameDuplicated: PassthroughSubject<String, MainError> = .init()
    let tapStoreButton: PassthroughSubject<UserEditableElement, MainError> = .init()
  }
  
  enum State {
    case none
    case networkProcessing
    case duplicatedNickname
    case availableNickname
    case correctionSaved
    case correctionNotSaved
  }
  
  // MARK: - Dependencies
  private let userInfoUseCase: UserInfoUseCase
  
  // MARK: - Properties
  private var hasProfileChanged = false
  private var changedNameAvailable = false
  private var isProcessingBothNameAndProfile = false
  
  /// 이미지, 프로필 둘 다 변경됬을 경우 완료를 알려주는 퍼블리셔
  private var bothNameAndProfileUpdatedPublisher: AnyPublisher<(Bool, Bool), MainError>
  private var hasUserInfoUpdatedPublisehr = PassthroughSubject<Bool, MainError>()
  
  // MARK: - Lifecycle
  init(userInfoUseCase: UserInfoUseCase) {
    self.userInfoUseCase = userInfoUseCase
    bothNameAndProfileUpdatedPublisher = Publishers.Zip(
      userInfoUseCase.isNicknameUpdated,
      userInfoUseCase.isProfileUpdated
    ).eraseToAnyPublisher()
  }
}

// MARK: - MyInformationViewModelable
extension MyInformationViewModel: MyInformationViewModelable {
  func transform(_ input: Input) -> Output {
    let isDuplicatedUserName = isDuplicatedUserNameStream(input: input)
    let checkDuplicatedUserName = checkDuplicatedUserNameStream()
    
    return Publishers.MergeMany([
      isDuplicatedUserName,
      checkDuplicatedUserName,
      hasNicknameUpdatedStream(),
      hasProfileUpdatedStream(),
      hasBothNameAndProfileUpdatedStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension MyInformationViewModel {
  func isDuplicatedUserNameStream(input: Input) -> Output {
    return input.isNicknameDuplicated.map { [weak self] nickname in
      self?.userInfoUseCase.checkIfNicknameDuplicate(with: nickname)
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
  
  func checkDuplicatedUserNameStream() -> Output {
    userInfoUseCase.isNicknameDuplicated.map { [weak self] isDuplicatedUserName -> State in
      self?.changedNameAvailable = isDuplicatedUserName
      return isDuplicatedUserName ? .duplicatedNickname : .availableNickname
    }.eraseToAnyPublisher()
  }
  
  func tapStoreButtonStream(input: Input) -> Output {
    return input.tapStoreButton
      .map { [weak self] (nickname, image) -> State in
        if self?.changedNameAvailable == self?.hasProfileChanged {
          self?.isProcessingBothNameAndProfile = true
        }
        if self?.changedNameAvailable == true, let nickname = nickname {
          self?.userInfoUseCase.updateNickname(with: nickname)
          self?.changedNameAvailable = false
        }
        if self?.hasProfileChanged == true, let image = image {
          // TODO: - 프로필 처음 저장 여부 파악해야합니다. 두번쨰이상일경우 update 호출해야합니다.
          /// userDefaults에 사용자의 프로필이 서버에 저장되어있는지 최초 확인해야합니다.
          /// 최초로 저장되어있다면, 그 다음부터는 update를 통해서만 (delete -> save) 서버에 추가해야한다고 합니다.
          /// 맨 처음 가입해서 들어올떄 자동으로 최초 한번 기본이미지 저장하는게 편할것 같습니다..
          self?.userInfoUseCase.updateProfile(with: image)
          self?.hasProfileChanged = false
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }

  func hasNicknameUpdatedStream() -> Output {
    return userInfoUseCase.isNicknameUpdated
      .map { [weak self] result -> State in
        guard self?.isProcessingBothNameAndProfile == true else {
          /// bothNameAndProfileUpdatePublisher를 통해서 저장 결과를 반영합니다.
          return .none
        }
        if result {
          return .correctionSaved
        }
        return .correctionNotSaved
      }.eraseToAnyPublisher()
  }
  
  func hasProfileUpdatedStream() -> Output {
    return userInfoUseCase.isProfileUpdated
      .map { [weak self] result -> State in
        guard self?.isProcessingBothNameAndProfile == true else {
          /// bothNameAndProfileUpdatePublisher를 통해서 저장 결과를 반영합니다.
          return .none
        }
        return result ? .correctionSaved : .correctionNotSaved
      }.eraseToAnyPublisher()

  }

  /// 프로필, 이미지 둘다 업데이트되는 경우 두개의 경우를 받은 후에 State를 반환합니다.
  func hasBothNameAndProfileUpdatedStream() -> Output {
    return bothNameAndProfileUpdatedPublisher
      .map { [weak self] (updatedNameResult, updatedProfileResult) -> State in
        self?.isProcessingBothNameAndProfile = false
        if updatedNameResult == updatedNameResult {
          return .correctionSaved
        }
        return .correctionNotSaved
      }.eraseToAnyPublisher()
  }
}
