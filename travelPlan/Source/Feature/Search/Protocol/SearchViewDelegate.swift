//
//  SearchViewDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/06/11.
//

import Foundation
import UIKit.UIButton

protocol SearchViewDelegate: AnyObject {
  func didTapSearchButton(_ searchView: SearchView, text: String)
}
