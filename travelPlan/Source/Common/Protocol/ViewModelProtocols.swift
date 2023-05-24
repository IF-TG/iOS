//
//  ViewModelProtocols.swift
//  travelPlan
//
//  Created by 양승현 on 2023/04/29.
//

protocol ViewBindCase {
  /// View UI render state
  associatedtype Input
  associatedtype State
  associatedtype ViewModelError
  func bind()
  func render(_ state: State)
}

protocol ViewModelAssociatedType {
  /// View's event publishers structure
  associatedtype Input
  /// View's render state publihser
  associatedtype Output
  /// View's render state
  associatedtype State
}

protocol ViewModelCase: ViewModelAssociatedType {
  /// Transform view's event publihsers to 1 output publhiser with UI render state
  func transform(_ input: Input) -> Output
}
