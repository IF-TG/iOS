//
//  UserInfoUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

protocol UserInfoUseCase {
  var isDuplicatedName: PassthroughSubject<Bool, MainError> { get }
  var isNicknameUpdated: PassthroughSubject<Bool, MainError> { get }
  
  func isDuplicatedName(with name: String)
  func updateNickname(with name: String)
}
