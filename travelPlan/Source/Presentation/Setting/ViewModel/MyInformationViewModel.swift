//
//  MyInformationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Foundation
import Combine

final class MyInformationViewModel {  
  // MARK: - Dependencies
  private let userNicknameSettingUseCase: UserNicknameSettingUseCase
  private let userProfileImageSettingUseCase: UserProfileImageSettingUseCase
  private let nicknameValidationUseCase: NicknameValidationUseCase
  private let loggedInUserUseCase: LoggedInUserUseCase
  private let actions: MyInformationViewModelActions
  
  // MARK: - Properties
  private var editedUserProfileImage: Data?
  private var editedUserNickname: String?
  private var changedNameAvailable = false
  private var isProcessingBothNameAndProfile = false
  private var ownerEntity: UserEntity?
  
  private var subscriptions = Set<AnyCancellable>()
  
  /// 이미지, 프로필 둘 다 변경됬을 경우 완료를 알려주는 퍼블리셔
  /// nil이 전달될 경우 특정한 updated...Notifier에서 에러가 났음을 의미
  private let bothNameAndProfileUpdatedPublisher: AnyPublisher<(Bool?, Bool?), Never>
  private let updatedNicknameNotifier = PassthroughSubject<Bool?, Never>()
  private let updatedProfileNotifier = PassthroughSubject<Bool?, Never>()
  private let nicknameUpdateSubject = PassthroughSubject<String, Never>()
  private let duplicatedNicknameCheckSubject = PassthroughSubject<String, Never>()
  private let profileUpdateSubject = PassthroughSubject<Data, Never>()
  private let profileSaveSubject = PassthroughSubject<Data, Never>()

  // MARK: - Lifecycle
  init(
    userNicknameSettingUseCase: UserNicknameSettingUseCase,
    userProfileImageSettingUseCase: UserProfileImageSettingUseCase,
    nicknameValidationUseCase: NicknameValidationUseCase,
    loggedInUserUseCase: LoggedInUserUseCase,
    actions: MyInformationViewModelActions
  ) {
    self.userNicknameSettingUseCase = userNicknameSettingUseCase
    self.userProfileImageSettingUseCase = userProfileImageSettingUseCase
    self.nicknameValidationUseCase = nicknameValidationUseCase
    self.loggedInUserUseCase = loggedInUserUseCase
    self.actions = actions
    bothNameAndProfileUpdatedPublisher = Publishers.Zip(
      updatedNicknameNotifier,
      updatedProfileNotifier).eraseToAnyPublisher()
  }
}

// MARK: - MyInformationViewModelable
extension MyInformationViewModel: MyInformationViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      checkDuplicatedUserNameStream(),
      selectProfileStream(input: input),
      tapStoreButtonStream(input: input),
      hasBothNameAndProfileUpdatedStream(),
      defaultNicknameStream(input: input),
      updateNicknameSubjectStream(),
      updateProfileStream(),
      inputNicknameStream(input: input),
      saveProfileStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension MyInformationViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ in
        /// 로그인한 사용자라면 반드시 ownerStorage에 사용자 정보가 저장되어야 합니다.
        guard let ownerEntity = self?.loggedInUserUseCase.user else {
          return .unexpectedError(description: "사용자 정보를 불러올 수 없습니다.")
        }
        self?.ownerEntity = ownerEntity
        return .viewDidLoad(ownerEntity)
      }.eraseToAnyPublisher()
  }
  
  func updateNicknameSubjectStream() -> Output {
    return nicknameUpdateSubject
      .flatMap { [weak self] nickname -> Output in
        guard let self else {
          return Just(State.unexpectedError(
            description: ReferenceError.invalidReference.localizedDescription)
          ).eraseToAnyPublisher()
        }
        editedUserNickname = nickname
        return userNicknameSettingUseCase
          .updateNickname(with: nickname)
          .map { [weak self] result -> State in
            if self?.isProcessingBothNameAndProfile == true {
              self?.updatedNicknameNotifier.send(result)
              return .none
            }
            if result {
              self?.changedNameAvailable = false
              self?.saveNicknameInOwnerUseCase(nickname)
            }
            return result ? .correctionSaved : .correctionNotSaved
          }.catch { [weak self] error -> Output in
            self?.updatedNicknameNotifier.send(nil)
            return Just(.unexpectedError(description: error.localizedDescription)).eraseToAnyPublisher()
          }.eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  func selectProfileStream(input: Input) -> Output {
    return input.profileSelect.map { [weak self] base64Image -> State in
      self?.editedUserProfileImage = base64Image
      return .none
    }.eraseToAnyPublisher()
  }
  
  // MARK: - 내부에서 서버에 검사까지 해줘서필요없음
  func checkDuplicatedUserNameStream() -> Output {
    duplicatedNicknameCheckSubject.flatMap { [weak self] nickname in
      return self?.nicknameValidationUseCase.isNicknameDuplicated(with: nickname)
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
          // MARK: 서버에 사용자 이미지가 저장되어있지 않다면, save를 통해 저장해야 합니다.
          // 사용자 이미지가 저장됬다면 update or delete -> save를 호출해야합니다.
          if self?.loggedInUserUseCase.hasProfileImageSavedInServer == true {
            self?.profileUpdateSubject.send(image)
          } else {
            self?.profileSaveSubject.send(image)
          }
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func updateProfileStream() -> Output {
    profileUpdateSubject.flatMap { [weak self] imageData -> Output in
      return self?.userProfileImageSettingUseCase.updateProfileImageData(with: imageData)
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
    profileSaveSubject.flatMap { [weak self] imageData -> Output in
      return self?.userProfileImageSettingUseCase.saveProfileImageData(with: imageData)
        .map { [weak self] result -> State in
          if self?.isProcessingBothNameAndProfile == true {
            self?.updatedProfileNotifier.send(result)
            return .none
          }
          if result {
            self?.saveProfileImageDataInOwnerUseCase(imageData)
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
      .map { [weak self] (updatedNameResult, updatedProfileResult) -> State in
        self?.isProcessingBothNameAndProfile = false
        if updatedNameResult == nil || updatedProfileResult == nil {
          /// 프로필 또는 이미지 한쪽에서 에러가 날 경우 해당 stream에서 에러 처리.
          return .none
        }
        if updatedNameResult == updatedProfileResult {
          self?.changedNameAvailable = false
          self?.editedUserProfileImage = nil
          self?.saveNicknameInOwnerUseCase(self?.editedUserNickname)
          return .correctionSaved
        }
        return .correctionNotSaved
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
  
  // FIXME: - DefaultNicknameValidationUseCase호출하도록!
  func inputNicknameStream(input: Input) -> Output {
    return input.revisedNicknameInput
      .debounce(for: 0.3, scheduler: DispatchQueue.main)
      .map { [weak self] editedNickname -> State in
        let isNicknameAvailable = (3...15).contains(editedNickname.count)
        let isNicknameWithinMinimumRange = (0...2).contains(editedNickname.count) || editedNickname.isEmpty
        
        guard let loggedInUserNickname = self?.ownerEntity?.nickname else {
          return .unexpectedError(description: "로그인한 사용자의 정보가 일치하지 않습니다. 잠시 후 다시 시도해주세요.")
        }
        if editedNickname == loggedInUserNickname {
          return .nicknameState(.default)
        }
        
        if isNicknameAvailable {
          self?.editedUserNickname = editedNickname
          // TODO: - activityIndicator로 리빌딩 해야합니다. 아니면 processing 반환 scope에서 다른 퍼블리셔에 send할때 백그라운드에서 호출하도록 변경해야합니다.
          DispatchQueue.global(qos: .background).async {
            self?.duplicatedNicknameCheckSubject.send(editedNickname)
          }
          return .networkProcessing
        }
        if isNicknameWithinMinimumRange {
          return .nicknameState(.underflow)
        }
        if editedNickname.count > 15 {
          return .nicknameState(.overflow)
        }
        return .none
      }.eraseToAnyPublisher()
  }
  
  func saveNicknameInOwnerUseCase(_ nickname: String?) {
    guard let nickname else {
      print("저장할 닉네임이 없습니다.")
      return
    }
    loggedInUserUseCase.updateNickname(with: nickname)
    ownerEntity?.nickname = nickname
  }
  
  func saveProfileImageDataInOwnerUseCase(_ profileImageData: Data?) {
    guard let profileImageData else {
      print("저장할 이미지가 없습니다.")
      return
    }
    loggedInUserUseCase.updateProfileImageData(with: profileImageData)
    ownerEntity?.profileImageData = profileImageData
  }
}

// MARK: - MyInformationViewModelPageDelegate
extension MyInformationViewModel: MyInformationViewModelPageDelegate {
  func showPrevPage() {
    guard hasUserEditedInfo() else {
      finish(withAnimation: true)
      return
    }
    showConfirmationAlertPage()
  }
  
  func finish(withAnimation: Bool) {
    actions.finishWithAnimation(withAnimation)
  }
  
  func showAlert(with description: String) {
    actions.showAlertForError(description, nil)
  }
  
  func showConfirmationAlertPage() {
    actions.showConfirmationAlertPage()
  }
  
  func showBottomSheetAlbum() {
    actions.showBottomSheetAlbum()
  }
  
  func finish() {
    actions.finish()
  }
}
