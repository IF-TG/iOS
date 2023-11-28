//
//  CellConfigurable.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/24.
//

import Foundation

/// 구체 타입에서 해당 프로토콜을 준수합니다.
/// 사용 시, typealias 키워드를 통해 매개변수 타입을 구체화합니다.
/// configure를 호출하는 쪽에서 Model 타입을 추상화하고, configure를 정의하는 쪽에서 Model타입을 구체화합니다.
/// 이때 Model은 Cell에서 사용되는 info입니다.
protocol CellConfigurable {
  associatedtype Info
  
  func configure(with info: Info?)
}
