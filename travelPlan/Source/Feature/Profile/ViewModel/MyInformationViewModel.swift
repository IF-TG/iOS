//
//  MyInformationViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2/28/24.
//

import Foundation
import Combine

struct MyInformationViewModel {
  struct Input {
    let isDuplicatedUserName: PassthroughSubject<String, Never>
  }
  
  enum State {
    case none
    case duplicatedNickname
    case availableNickname
  }
}
