//
//  UserInfoUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

protocol UserInfoUseCase {
  var isDuplicatedName: Bool? { get }
  func isDuplicatedName(with name: String)
}