//
//  ViewModelProtocols.swift
//  travelPlan
//
//  Created by 양승현 on 2023/04/29.
//

import Combine

/// ViewController나 View에서 ViewModel Output에 대해 bind할 수 있는 경우
///
/// - Associatedtype Input : *ViewModel.Input
/// - Associatedtype ErrorType : *ViewModel.ErrorType
/// - Associatedtype State : *ViewModel.State
///
/// Notes:
/// 1. VIewModel에서 protocol의 associatedtype를 준수할 것임으로 *ViewModle.*이렇게 지정해야 합니다.
protocol ViewBindAssociatedType {
  associatedtype Input
  associatedtype ErrorType: Error
  associatedtype State
}

/// ViewModel에서 발생될 수 있는 associatedtype를 지정했습니다.
///
/// - Associatedtype Output : AnyPublisher<State, ErrorType>
///
/// Notes:
/// 1. ViewModel에서 Output 타입이 구현될 것입니다. 추후 Extension으로 코드를 구현하기 쉽게 하기 위해서 만들었습니다.
/// 2.  중복되는 코드를 간소화 했습니다. ( ViewBindAssociatedType 재사용 )
protocol ViewModelAssociatedType: ViewBindAssociatedType {
  associatedtype Output where Output == AnyPublisher<State, ErrorType>
}

/// UIView나 UIViewController에서 준수하면 편하게 사용될 수 있습니다.
///
/// Notes:
/// 1. ViewBindAssociatedType의 typealias를 지정해야 합니다.
protocol ViewBindCase: ViewBindAssociatedType {
  /// View UI render state
  func bind()
  func render(_ state: State)
  func handleError(_ error: ErrorType)
}

protocol ViewModelCase: ViewModelAssociatedType {
  /// Transform view's event publihsers to 1 output publhiser with UI render state
  func transform(_ input: Input) -> Output
}
