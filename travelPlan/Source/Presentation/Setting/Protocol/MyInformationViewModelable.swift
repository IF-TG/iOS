//
//  MyInformationViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Combine
import Foundation

protocol MyInformationViewModelPageDelegate: AnyObject {
  func showConfirmationAlertPage()
  func showBottomSheetAlbum()
  func showAlert(with description: String)
  func showPrevPage()
  func finish()
  func finish(withAnimation: Bool)
}

struct MyInformationViewModelActions {
  let showConfirmationAlertPage: () -> Void
  let showBottomSheetAlbum: () -> Void
  let showAlertForError: (String, (() -> Void)?) -> Void
  let finish: () -> Void
  let finishWithAnimation: (Bool) -> Void
}

struct MyInformationViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let profileSelect: PassthroughSubject<Data?, Never> = .init()
  let saveButtonTap: PassthroughSubject<Void, Never> = .init()
  let defaultNickname: PassthroughSubject<Void, Never> = .init()
  let revisedNicknameInput: PassthroughSubject<String, Never> = .init()
}

enum MyInformationViewModelState {
  case none
  case viewDidLoad(UserEntity)
  case networkProcessing
  case savableState(Bool)
  case nicknameState(SettingUserNameTextField.State)
  case correctionSaved
  case correctionNotSaved
  case unexpectedError(description: String)
}

protocol MyInformationViewModelable: ViewModelable
where Input == MyInformationViewModelInput,
      State == MyInformationViewModelState,
      Output == AnyPublisher<State, Never> { }
