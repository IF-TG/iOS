//
//  AppDIContainer.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

final class YeoGaAssembler {
  private(set) var assembler: Assembler
  
  private init() {
    self.assembler = Assembler([])
  }
}
