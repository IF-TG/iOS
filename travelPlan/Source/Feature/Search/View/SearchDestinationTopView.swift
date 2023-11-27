//
//  SearchDestinationTopView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/27/23.
//

import UIKit
import SnapKit

class SearchDestinationTopView: UIView {
  // MARK: - Properties
  private let titleLabel = UILabel().set {
    $0.textColor = .yg.gray7
    $0.font = .init(pretendard: .medium_500(fontSize: 22))
    $0.text = "타이틀"
  }
}
