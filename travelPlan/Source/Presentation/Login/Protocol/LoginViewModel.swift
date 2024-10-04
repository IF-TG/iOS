//
//  LoginViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 10/1/24.
//

import Foundation
import Combine

typealias LoginViewModel = LoginViewModelable & LoginViewModelPageDelegate

struct LoginViewModelInput {
  let didTapLoginButton: PassthroughSubject<OAuthType, Never> = .init()
}

enum LoginViewModelState {
  case none
  case presentFeed
}

protocol LoginViewModelable: ViewModelable
where LoginViewModelInput == Input,
      LoginViewModelState == State {}

protocol LoginViewModelPageDelegate: AnyObject {
  func showFeedPage()
}
