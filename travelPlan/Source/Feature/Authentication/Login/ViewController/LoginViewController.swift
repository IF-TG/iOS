//
//  LoginViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
  // MARK: - Properteis
  let vm = LoginViewModel()
  let appear = PassthroughSubject<Void, ErrorType>()
  let viewLoad = PassthroughSubject<Void, ErrorType>()
  var subscription = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    viewLoad.send()
    view.backgroundColor = .brown
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appear.send()
  }
  
}

// MARK: - ViewBindCase
extension LoginViewController: ViewBindCase {
  typealias Input = LoginViewModel.Input
  typealias ErrorType = LoginViewModel.ErrorType
  typealias State = LoginViewModel.State
  
  func bind() {
    let input = Input(
      appear: appear.eraseToAnyPublisher(),
      viewLoad: viewLoad.eraseToAnyPublisher())
    let output = vm.transform(input)
    output.sink { [weak self] completion in
      switch completion {
      case .finished: break
      case .failure(let error):
        self?.handleError(error)
      }
    } receiveValue: { [weak self] in
      self?.render($0)
    }.store(in: &subscription)
    
  }
  
  func render(_ state: State) {
    switch state {
    case .none:
      print("none")
    case .appear:
      print("appear")
    case .viewLoad:
      print("viewLoaded")
    }
  }
  
  func handleError(_ error: LoginViewModel.ErrorType) {
    switch error {
    case .none:
      print("none")
    case .unexpectedError:
      print("unexpectedError")
    }
  }
}
