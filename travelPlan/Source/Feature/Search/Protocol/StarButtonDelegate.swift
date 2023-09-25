//
//  StarButtonDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/24.
//

import UIKit

protocol StarButtonDelegate: AnyObject {
  func didTapStarButton<T: UIView & CellConfigurable>(_ baseView: BaseDestinationView<T>)
}
