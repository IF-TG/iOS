//
//  SettingViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 4/13/24.
//

import Foundation
import Combine

final class SettingViewModel {
  // MARK: - Dependencies
  private let owenrRepository: LoggedInUserRepository
  
  // MARK: - Properties
  private let actions: SettingViewModelActions
  
  // MARK: - Lifecycle
  init(
    owenrRepository: LoggedInUserRepository,
    actions: SettingViewModelActions
  ) {
    self.owenrRepository = owenrRepository
    self.actions = actions
  }
}

// MARK: - SettingViewModelable
extension SettingViewModel: SettingViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
      viewDidLoadStream(input: input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Input Stream Helper
private extension SettingViewModel {
  func viewDidLoadStream(input: Input) -> Output {
    return input.viewDidLoad.map { [weak self] _ -> State in
      let username = self?.owenrRepository.nickname
      let profileImageData = self?.owenrRepository.profileImageData
      return .viewDidLoad((username, profileImageData))
    }.eraseToAnyPublisher()
  }
}

// MARK: - SettingViewModelPageDelegate
extension SettingViewModel: SettingViewModelPageDelegate {
  func showOperationGuidePage() {
    actions.showOperationGuidePage()
  }
  
  func showMyInformationPage() {
    actions.showMyInformationPage()
  }
  
  func showCustomerServicePage() {
    actions.showCustomerServicePage()
  }
  
  func finish() {
    actions.finish()
  }
}
