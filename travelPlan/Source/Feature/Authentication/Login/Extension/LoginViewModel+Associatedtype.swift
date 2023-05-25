//
//  LoginViewModel+Associatedtype.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

extension LoginViewModel: ViewModelAssociatedType {
  struct Input {
    let appear: AnyPublisher<Void, ErrorType>
    let viewLoad: AnyPublisher<Void, ErrorType>
  }
  
  enum ErrorType: Error {
    case none
    case unexpectedError
  }
  
  enum State {
    case appear
    case viewLoad
    case none
  }
  
  typealias Output = AnyPublisher<State, ErrorType>
}
