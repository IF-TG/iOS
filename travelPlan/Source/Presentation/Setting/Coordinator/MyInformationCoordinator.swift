//
//  MyInformationCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 3/16/24.
//

import UIKit
import SHCoordinator
import Combine
import SHFirestoreService

final class MyInformationCoordinator: FlowCoordinator {
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  
  var presenter: UINavigationController?
  
  var viewController: UIViewController?
  
  var alubmImageChoiceSubscription: AnyCancellable?
  
  private let profileImageMemoryCache = ImageMemoryCache()
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  func start() {
    let firestoreService = FirestoreService()
    let firebaseStorageService = FirebaseStorageService()
    let stubOwnerStorage = StubOwnerStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: .init(value: stubOwnerStorage))
    let loggedInUserUseCase = DefaultLoggedInUserUseCase(loggedInUserRepository: loggedInUserRepository)
    
    let userProfileSettingRepository = FirestoreUserProfileSettingRepository(
      service: firestoreService,
      firebaseStorageService: firebaseStorageService,
      ownerStorage: stubOwnerStorage)
    let userProfileImageSettingUseCase = DefaultUserProfileImageSettingUseCase(
      userProfileSettingRepository: userProfileSettingRepository)
    
    let userNicknameSettingUseCase = DefaultUserNicknameSettingUseCase(
      userProfileSettingRepository: userProfileSettingRepository)
    
    let nicknameValidationUseCase = DefaultNicknameValidationUseCase(
      userProfileSettingRepository: userProfileSettingRepository,
      ownerStorage: stubOwnerStorage)
    
    let actions = MyInformationViewModelActions { [weak self] in
      self?.showConfirmationAlertPage()
    } showBottomSheetAlbum: { [weak self] in
      self?.showBottomSheetAlbum()
    } showAlertForError: { [weak self] description, completion in
      self?.showAlertForError(with: description, completion: completion)
    } finish: { [weak self] in
      self?.finish()
    } finishWithAnimation: { [weak self] animate in
      self?.finish(withAnimated: animate)
    }

    let viewModel = MyInformationViewModel(
      userNicknameSettingUseCase: userNicknameSettingUseCase,
      userProfileImageSettingUseCase: userProfileImageSettingUseCase,
      nicknameValidationUseCase: nicknameValidationUseCase,
      loggedInUserUseCase: loggedInUserUseCase,
      actions: actions)
    let viewController = MyInformationViewController(viewModel: viewModel)
    self.viewController = viewController
    presenter?.pushViewController(viewController, animated: true)
  }
}

// MARK: - Actions Helpers
extension MyInformationCoordinator {
  func showConfirmationAlertPage() {
    let alert = UIAlertController(title: nil, message: "프로필을 수정하지 않으시겠습니까?", preferredStyle: .alert)
    let yes = UIAlertAction(title: "예", style: .default) { [weak self] _ in
      self?.finish(withAnimated: true)
    }
    let no = UIAlertAction(title: "아니요", style: .cancel)
    [yes, no].forEach { alert.addAction($0) }
    viewController?.present(alert, animated: true, completion: nil)
  }
  
  func showBottomSheetAlbum() {
    let albumSheet = MyInformationAlbumSheetViewController()
    alubmImageChoiceSubscription = albumSheet.$hasSelectedProfile
      .subscribe(on: DispatchQueue.main)
      .compactMap { $0 }
      .sink { [weak self] image in
        (self?.viewController as? MyInformationViewController)?.handleSelectedImage(with: image)
      }
    viewController?.presentBottomSheet(albumSheet)
  }
  
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        completion?()
      })
    }
    viewController?.present(alert, animated: true)
  }
}
