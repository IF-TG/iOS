//
//  BottomNextPageIndicatorCell.swift
//  travelPlan
//
//  Created by 양승현 on 3/21/24.
//

import UIKit

class BottomNextPageIndicatorCell: UICollectionViewCell {
  static let identifier = String(describing: BottomNextPageIndicatorCell.self)
  
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  
  func startIndicator() {
    indicator.startAnimating()
  }
  
  func stopIndicator() {
    indicator.stopAnimating()
  }
}
