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
  private let loggedInUserUseCase: LoggedInUserUseCase
  
  // MARK: - Properties
  private let actions: SettingViewModelActions
  
  // MARK: - Lifecycle
  init(
    loggedInUserUseCase: LoggedInUserUseCase,
    actions: SettingViewModelActions
  ) {
    self.loggedInUserUseCase = loggedInUserUseCase
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
      let username = self?.loggedInUserUseCase.nickname
      let profile = self?.loggedInUserUseCase.profileURL
      // TODO: - 로그인한 사용자 유즈케이스에서 가져올떄 Data로 타입 변환해야함......
      return .viewDidLoad((username, nil))
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
