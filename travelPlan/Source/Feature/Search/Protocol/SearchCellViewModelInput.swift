//
//  SearchCellViewModelInput.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/17.
//

import Foundation
import Combine

protocol SearchCellViewModelInput {
  associatedtype ErrorType: Error
  var didTapHeartButton: PassthroughSubject<Void, ErrorType> { get }
}
