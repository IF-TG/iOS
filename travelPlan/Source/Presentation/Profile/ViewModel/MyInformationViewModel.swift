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
    let isNicknameDuplicated: PassthroughSubject<String, MainError> = .init()
    let selectProfile: PassthroughSubject<String?, MainError> = .init()
    let tapStoreButton: PassthroughSubject<Void, MainError> = .init()
    let tapBackButton: PassthroughSubject<Void, MainError> = .init()
  }
  
  enum State {
    case none
    case networkProcessing
    case duplicatedNickname
    case availableNickname
    case correctionSaved
    case correctionNotSaved
    case wannaLeaveThisPage(hasUserEditedInfo: Bool)
  }
  
  // MARK: - Dependencies
  private let myProfileUseCase: MyProfileUseCase
  
  // MARK: - Properties
  private var editedUserProfileImage: String?
  private var editedUserNickname: String?
  private var changedNameAvailable = false
  private var isProcessingBothNameAndProfile = false
  
  /// 이미지, 프로필 둘 다 변경됬을 경우 완료를 알려주는 퍼블리셔
  private var bothNameAndProfileUpdatedPublisher: AnyPublisher<(Bool, Bool), MainError>
  private var hasUserInfoUpdatedPublisehr = PassthroughSubject<Bool, MainError>()
  
  // MARK: - Lifecycle
  init(myProfileUseCase: MyProfileUseCase) {
    self.myProfileUseCase = myProfileUseCase
    bothNameAndProfileUpdatedPublisher = Publishers.Zip(
      myProfileUseCase.isNicknameUpdated,
      myProfileUseCase.isProfileUpdated
    ).eraseToAnyPublisher()
  }
}

// MARK: - MyInformationViewModelable
extension MyInformationViewModel: MyInformationViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      isDuplicatedUserNameStream(input: input),
      checkDuplicatedUserNameStream(),
      selectProfileStream(input: input),
      tapStoreButtonStream(input: input),
      hasNicknameUpdatedStream(),
      hasProfileUpdatedStream(),
      hasBothNameAndProfileUpdatedStream(),
      tapBackBarButtonStream(input: input)]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension MyInformationViewModel {
  func selectProfileStream(input: Input) -> Output {
    return input.selectProfile.map { [weak self] base64Image -> State in
      self?.editedUserProfileImage = base64Image
      return .none
    }.eraseToAnyPublisher()
  }
  
  func isDuplicatedUserNameStream(input: Input) -> Output {
    return input.isNicknameDuplicated.map { [weak self] nickname in
      self?.editedUserNickname = nickname
      self?.myProfileUseCase.checkIfNicknameDuplicate(with: nickname)
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
  
  func checkDuplicatedUserNameStream() -> Output {
    myProfileUseCase.isNicknameDuplicated.map { [weak self] isDuplicatedUserName -> State in
      self?.changedNameAvailable = !isDuplicatedUserName
      if isDuplicatedUserName {
        self?.editedUserNickname = nil
      }
      return isDuplicatedUserName ? .duplicatedNickname : .availableNickname
    }.eraseToAnyPublisher()
  }
  
  func tapStoreButtonStream(input: Input) -> Output {
    return input.tapStoreButton
      .map { [weak self] _ -> State in
        if self?.changedNameAvailable == true, self?.editedUserProfileImage != nil {
          self?.isProcessingBothNameAndProfile = true
        }
        if self?.changedNameAvailable == true, let nickname = self?.editedUserNickname {
          self?.myProfileUseCase.updateNickname(with: nickname)
          self?.changedNameAvailable = false
        }
        if let image = self?.editedUserProfileImage {
          /// userDefaults에 사용자의 프로필이 서버에 저장되어있는지 최초 확인해야합니다.
          /// 최초로 저장되어있다면, 그 다음부터는 update를 통해서만 (delete -> save) 서버에 추가해야한다고 합니다.
          /// 맨 처음 가입해서 들어올떄 자동으로 최초 한번 기본이미지 저장하는게 편할것 같습니다...
          if self?.myProfileUseCase.isProfileSavedInServer == true {
            self?.myProfileUseCase.updateProfile(with: image)
          } else {
            self?.myProfileUseCase.saveProfile(with: image)
          }
          self?.editedUserProfileImage = nil
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }

  func hasNicknameUpdatedStream() -> Output {
    return myProfileUseCase.isNicknameUpdated
      .map { [weak self] result -> State in
        if self?.isProcessingBothNameAndProfile == true {
          /// bothNameAndProfileUpdatePublisher를 통해서 저장 결과를 반영합니다.
          return .none
        }
        return result ? .correctionSaved : .correctionNotSaved
      }.eraseToAnyPublisher()
  }
  
  func hasProfileUpdatedStream() -> Output {
    return myProfileUseCase.isProfileUpdated
      .map { [weak self] result -> State in
        if self?.isProcessingBothNameAndProfile == true {
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
        if updatedNameResult == updatedProfileResult {
          return .correctionSaved
        }
        return .correctionNotSaved
      }.eraseToAnyPublisher()
  }
  
  func tapBackBarButtonStream(input: Input) -> Output {
    return input.tapBackButton
      .map { [weak self] _ -> State in
        let hasUserEditedInfo = self?.hasUserEditedInfo()
        return .wannaLeaveThisPage(hasUserEditedInfo: hasUserEditedInfo ?? false)
      }.eraseToAnyPublisher()
  }
  
  func hasUserEditedInfo() -> Bool {
    if changedNameAvailable || editedUserProfileImage != nil {
      return true
    }
    return false
  }
}
