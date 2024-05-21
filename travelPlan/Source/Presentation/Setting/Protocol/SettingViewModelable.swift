//
//  SettingViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/13/24.
//

import Foundation
import Combine
import SHCoordinator

protocol SettingViewModelPageDelegate: AnyObject {
  func showOperationGuidePage()
  func showMyInformationPage()
  func showCustomerServicePage()
  func finish()
}

struct SettingViewModelActions {
  let showOperationGuidePage: () -> Void
  let showMyInformationPage: () -> Void
  let showCustomerServicePage: () -> Void
  let finish: () -> Void
}

struct SettingViewModelInput {
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
}

@frozen enum SettingViewModelState {
  typealias OwnerNickname = String
  typealias OwnerProfileImageData = Data
  case viewDidLoad((OwnerNickname?, OwnerProfileImageData?))
}

protocol SettingViewModelable: ViewModelable
where Input == SettingViewModelInput,
      State == SettingViewModelState,
      Output == AnyPublisher<State, Never> { }
