//
//  Builder.swift
//  travelPlan
//
//  Created by 양승현 on 6/27/24.
//

import Foundation

protocol Builder {
  associatedtype Product
  
  func build() -> Product
}
