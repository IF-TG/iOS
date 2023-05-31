//
//  PostSearchTagCellDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/20.
//

import Foundation
import UIKit

protocol PostSearchTagCellDelegate: AnyObject {
  func didTapDeleteButton(item: Int, in section: Int)
}
