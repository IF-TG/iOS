//
//  MyInformationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Foundation
import Combine

// MARK: - Error
enum MyInforMationViewModelError: LocalizedError {
  case unknown(description: String)
  case userInformationNotFound(description: String)
  case connectionError(ConnectionError)
  
  var errorDescription: String? {
    switch self {
    case .unknown(let description):
      NSLocalizedString(description, comment: "")
    case .userInformationNotFound(let description):
      NSLocalizedString(description, comment: "")
    case .connectionError(let connectionError):
      connectionError.localizedDescription
    }
  }
}

// MARK: - Extension
private extension Publisher {
  func mapViewModelError<E>(
    _ transform: @escaping (Self.Failure) -> E
  ) -> Publishers.MapError<Self, MyInforMationViewModelError> {
    return self.mapError { error -> MyInforMationViewModelError in
      if let useCaseError = error as? MyProfileUseCaseError {
        return switch useCaseError {
        case .invalidUserId:
          MyInforMationViewModelError.userInformationNotFound(description: useCaseError.localizedDescription)
        case .networkError(let connectionError):
          MyInforMationViewModelError.connectionError(connectionError)
        }
      }
      return MyInforMationViewModelError.unknown(description: error.localizedDescription)
    }
  }
}

// MARK: - MyInformationViewModel
final class MyInformationViewModel {
  struct Input {
    let isNicknameDuplicated: PassthroughSubject<String, MyInforMationViewModelError> = .init()
    let selectProfile: PassthroughSubject<String?, MyInforMationViewModelError> = .init()
    let tapStoreButton: PassthroughSubject<Void, MyInforMationViewModelError> = .init()
    let tapBackButton: PassthroughSubject<Void, MyInforMationViewModelError> = .init()
    let defaultNickname: PassthroughSubject<Void, MyInforMationViewModelError> = .init()
    let inputNickname: PassthroughSubject<String, MyInforMationViewModelError> = .init()
  }
  
  enum State {
    case none
    case networkProcessing
    case savableState(Bool)
    case nicknameState(SettingUserNameTextField.State)
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
  private var bothNameAndProfileUpdatedPublisher: AnyPublisher<(Bool, Bool), MyInforMationViewModelError>
  private var updatedNicknameNotifier = PassthroughSubject<Bool, MyInforMationViewModelError>()
  private var updatedProfileNotifier = PassthroughSubject<Bool, MyInforMationViewModelError>()
  private var hasUserInfoUpdatedPublisehr = PassthroughSubject<Bool, MyInforMationViewModelError>()
  
  // MARK: - Lifecycle
  init(myProfileUseCase: MyProfileUseCase) {
    self.myProfileUseCase = myProfileUseCase
    bothNameAndProfileUpdatedPublisher = Publishers.Zip(
      updatedNicknameNotifier,
      updatedProfileNotifier).eraseToAnyPublisher()
  }
}

// MARK: - MyInformationViewModelable
extension MyInformationViewModel: MyInformationViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      checkDuplicatedUserNameStream(),
      selectProfileStream(input: input),
      tapStoreButtonStream(input: input),
      hasNicknameUpdatedStream(),
      hasProfileUpdatedStream(),
      hasBothNameAndProfileUpdatedStream(),
      tapBackBarButtonStream(input: input),
      defaultNicknameStream(input: input),
      inputNicknameStream(input: input)]
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
  
  func checkDuplicatedUserNameStream() -> Output {
    myProfileUseCase.isNicknameDuplicated.map { [weak self] isDuplicatedUserName -> State in
      self?.changedNameAvailable = !isDuplicatedUserName
      if isDuplicatedUserName {
        self?.editedUserNickname = nil
      }
      print(isDuplicatedUserName)
      return .nicknameState(isDuplicatedUserName ? .duplicated : .available)
    }
    .mapViewModelError { $0 }
    .eraseToAnyPublisher()
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
      }
      .mapViewModelError { $0 }
      .eraseToAnyPublisher()
  }

  func hasNicknameUpdatedStream() -> Output {
    return myProfileUseCase.isNicknameUpdated
      .map { [weak self] result -> State in
        if self?.isProcessingBothNameAndProfile == true {
          self?.updatedNicknameNotifier.send(result)
          return .none
        }
        return result ? .correctionSaved : .correctionNotSaved
      }
      .mapViewModelError { $0 }
      .eraseToAnyPublisher()
  }
  
  func hasProfileUpdatedStream() -> Output {
    return myProfileUseCase.isProfileUpdated
      .map { [weak self] result -> State in
        if self?.isProcessingBothNameAndProfile == true {
          self?.updatedProfileNotifier.send(result)
          return .none
        }
        return result ? .correctionSaved : .correctionNotSaved
      }
      .mapViewModelError { $0 }
      .eraseToAnyPublisher()

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
  
  func defaultNicknameStream(input: Input) -> Output {
    return input.defaultNickname
      .map { [weak self] _ -> State in
        if self?.editedUserProfileImage != nil {
          return .savableState(true)
        }
        return .savableState(false)
      }.eraseToAnyPublisher()
  }
  
  func inputNicknameStream(input: Input) -> Output {
    return input.inputNickname
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .map { [weak self] editedNickname -> State in
        let isNicknameAvailable = (3...15).contains(editedNickname.count)
        let isNicknameWithinMinimumRange = (0...2).contains(editedNickname.count) || editedNickname.isEmpty
        if isNicknameAvailable {
          self?.editedUserNickname = editedNickname
          self?.myProfileUseCase.checkIfNicknameDuplicate(with: editedNickname)
          return .networkProcessing
        }
        if isNicknameWithinMinimumRange {
          return .nicknameState(.underflow)
        }
        if editedNickname.count > 15 {
          return .nicknameState(.overflow)
        }
        // TODO: - 사용자의 닉네임과 같은 경우. 유저디폴츠에서 가져와야합니다.
        if editedNickname == "야호호" {
          return .nicknameState(.default)
        }
        return .none
      }.eraseToAnyPublisher()
  }
}
