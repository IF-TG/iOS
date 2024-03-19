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
        case .unknown(let errorDescription):
          MyInforMationViewModelError.unknown(description: errorDescription)
        }
      }
      return MyInforMationViewModelError.unknown(description: error.localizedDescription)
    }
  }
}

// MARK: - MyInformationViewModel
final class MyInformationViewModel {
  struct Input {
    let profileSelect: PassthroughSubject<String?, Never> = .init()
    let saveButtonTap: PassthroughSubject<Void, Never> = .init()
    let backBarButtonTap: PassthroughSubject<Void, Never> = .init()
    let defaultNickname: PassthroughSubject<Void, Never> = .init()
    let revisedNicknameInput: PassthroughSubject<String, Never> = .init()
  }
  
  enum State {
    case none
    case networkProcessing
    case savableState(Bool)
    case nicknameState(SettingUserNameTextField.State)
    case correctionSaved
    case correctionNotSaved
    case wannaLeaveThisPage(hasUserEditedInfo: Bool)
    case unexpectedError(description: String)
  }
  
  // MARK: - Dependencies
  private var myProfileUseCase: MyProfileUseCase
  
  // MARK: - Properties
  private var editedUserProfileImage: String?
  private var editedUserNickname: String?
  private var changedNameAvailable = false
  private var isProcessingBothNameAndProfile = false
  
  private var subscriptions = Set<AnyCancellable>()
  
  /// 이미지, 프로필 둘 다 변경됬을 경우 완료를 알려주는 퍼블리셔
  /// nil이 전달될 경우 특정한 updated...Notifier에서 에러가 났음을 의미
  private let bothNameAndProfileUpdatedPublisher: AnyPublisher<(Bool?, Bool?), Never>
  private let updatedNicknameNotifier = PassthroughSubject<Bool?, Never>()
  private let updatedProfileNotifier = PassthroughSubject<Bool?, Never>()
  private let nicknameUpdateSubject = PassthroughSubject<String, Never>()
  private let duplicatedNicknameCheckSubject = PassthroughSubject<String, Never>()
  private let profileUpdateSubject = PassthroughSubject<String, Never>()
  private let profileSaveSubject = PassthroughSubject<String, Never>()

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
      hasBothNameAndProfileUpdatedStream(),
      tapBackBarButtonStream(input: input),
      defaultNicknameStream(input: input),
      inputNicknameStream(input: input),
      updateNicknameSubjectStream(),
      updateProfileStream(),
      inputNicknameStream(input: input),
      saveProfileStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension MyInformationViewModel {
  func updateNicknameSubjectStream() -> Output {
    return nicknameUpdateSubject
      .flatMap { [weak self] nickname in
      return self?.myProfileUseCase.updateNickname(with: nickname)
          .mapViewModelError { $0 }
        .map { [weak self] result in
          if self?.isProcessingBothNameAndProfile == true {
            self?.updatedNicknameNotifier.send(result)
            return .none
          }
          if result {
            self?.changedNameAvailable = false
          }
          return result ? .correctionSaved : .correctionNotSaved
        }.catch { [weak self] error in
          self?.updatedNicknameNotifier.send(nil)
          return Just(State.unexpectedError(description: error.errorDescription ?? "앱 동작 에러가 발생됬습니다."))
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher() ?? Just(
          State.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")).eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
  }
  
  func selectProfileStream(input: Input) -> Output {
    return input.profileSelect.map { [weak self] base64Image -> State in
      self?.editedUserProfileImage = base64Image
      return .none
    }.eraseToAnyPublisher()
  }
  
  func checkDuplicatedUserNameStream() -> Output {
    duplicatedNicknameCheckSubject.flatMap { [weak self] nickname in
      return self?.myProfileUseCase.checkIfNicknameDuplicate(with: nickname)
        .mapViewModelError { $0 }
        .map { [weak self] isNicknameDuplicated -> State in
          self?.changedNameAvailable = !isNicknameDuplicated
          if isNicknameDuplicated {
            self?.editedUserNickname = nil
          }
          return .nicknameState(isNicknameDuplicated ? .duplicated : .available)
        }.catch { error in
          return Just(State.unexpectedError(description: error.localizedDescription))
            .eraseToAnyPublisher()
        }.eraseToAnyPublisher() ?? Just(
          .unexpectedError(description: "앱 내부 참조 에러가 발생됬습니다.")
        ).eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  func tapStoreButtonStream(input: Input) -> Output {
    return input.saveButtonTap
      .map { [weak self] _ -> State in
        if self?.changedNameAvailable == true, self?.editedUserProfileImage != nil {
          self?.isProcessingBothNameAndProfile = true
        }
        if self?.changedNameAvailable == true, let nickname = self?.editedUserNickname {
          self?.nicknameUpdateSubject.send(nickname)
        }
        if let image = self?.editedUserProfileImage {
          /// userDefaults에 사용자의 프로필이 서버에 저장되어있는지 최초 확인해야합니다.
          /// 최초로 저장되어있다면, 그 다음부터는 update를 통해서만 (delete -> save) 서버에 추가해야한다고 합니다.
          /// 맨 처음 가입해서 들어올떄 자동으로 최초 한번 기본이미지 저장하는게 편할것 같습니다...
          if self?.myProfileUseCase.isProfileSavedInServer == true {
            self?.profileUpdateSubject.send(image)
          } else {
            self?.profileSaveSubject.send(image)
          }
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func updateProfileStream() -> Output {
    profileUpdateSubject.flatMap { [weak self] imageString -> Output in
      return self?.myProfileUseCase.updateProfile(with: imageString)
        .mapViewModelError { $0 }
        .map { [weak self] result -> State in
          if self?.isProcessingBothNameAndProfile == true {
            self?.updatedProfileNotifier.send(result)
            return .none
          }
          if result {
            self?.editedUserProfileImage = nil
          }
          return result ? .correctionSaved : .correctionNotSaved
        }.catch { [weak self] error -> Output in
          self?.updatedProfileNotifier.send(nil)
          return Just(.unexpectedError(description: error.localizedDescription))
            .eraseToAnyPublisher()
        }.eraseToAnyPublisher() ?? Just(
          .unexpectedError(description: "앱 내부 참조 에러가 발생했습니다."))
        .eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  func saveProfileStream() -> Output {
    profileSaveSubject.flatMap { [weak self] imageString -> Output in
      return self?.myProfileUseCase.saveProfile(with: imageString)
        .mapViewModelError { $0 }
        .map { [weak self] result -> State in
          if self?.isProcessingBothNameAndProfile == true {
            self?.updatedProfileNotifier.send(result)
            return .none
          }
          if result {
            self?.editedUserProfileImage = nil
          }
          return result ? .correctionSaved : .correctionNotSaved
        }.catch { [weak self] error -> AnyPublisher<State, Never> in
          self?.updatedProfileNotifier.send(nil)
          return Just(.unexpectedError(description: error.localizedDescription))
            .eraseToAnyPublisher()
        }.eraseToAnyPublisher() ?? Just(
          .unexpectedError(description: "앱 내부 참조 에러가 발생했습니다.")
        ).eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }

  /// 프로필, 이미지 둘다 업데이트되는 경우 두개의 경우를 받은 후에 State를 반환합니다.
  func hasBothNameAndProfileUpdatedStream() -> Output {
    return bothNameAndProfileUpdatedPublisher
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .map { [weak self] (updatedNameResult, updatedProfileResult) -> State in
        self?.isProcessingBothNameAndProfile = false
        if updatedNameResult == nil || updatedProfileResult == nil {
          /// 프로필 또는 이미지 한쪽에서 에러가 날 경우 해당 stream에서 에러 처리.
          return .none
        }
        if updatedNameResult == updatedProfileResult {
          self?.changedNameAvailable = false
          self?.editedUserProfileImage = nil
          return .correctionSaved
        }
        return .correctionNotSaved
      }.eraseToAnyPublisher()
  }
  
  func tapBackBarButtonStream(input: Input) -> Output {
    return input.backBarButtonTap
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
  
  /// 프로필만 수정한 경우 (이름은 기본 설정된 이름인지? 여부에 따라서 저장 기능 허용)
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
    return input.revisedNicknameInput
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .map { [weak self] editedNickname -> State in
        let isNicknameAvailable = (3...15).contains(editedNickname.count)
        let isNicknameWithinMinimumRange = (0...2).contains(editedNickname.count) || editedNickname.isEmpty
        if isNicknameAvailable {
          self?.editedUserNickname = editedNickname
          self?.duplicatedNicknameCheckSubject.send(editedNickname)
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
