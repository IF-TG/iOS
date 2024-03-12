//
//  ReviewWritingContentViewDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 11/14/23.
//

import Foundation

protocol ReviewWritingContentViewDelegate: AnyObject {
  func changeContentInset(bottomEdge: CGFloat)
  func handleFinishButtonTitleColor(isEnabled: Bool)
}