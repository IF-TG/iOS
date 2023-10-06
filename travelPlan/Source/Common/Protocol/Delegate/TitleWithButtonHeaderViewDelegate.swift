//
//  TitleWithButtonHeaderViewDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/15.
//

import UIKit.UIButton

/// 헤더뷰의 버튼이 눌렸을 때, 매개변수를 통해 해당 헤더뷰의 sectionIndex 알려줍니다.
protocol TitleWithButtonHeaderViewDelegate: AnyObject {
  func didTaplookingMoreButton(_ button: UIButton, in section: Int)
}
