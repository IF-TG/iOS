//
//  PostSearchTagLabel.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/01.
//

import UIKit

class PostSearchTagLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupStyles() {
    self.font = UIFont(pretendard: .medium, size: Constants.fontSize)
    self.textColor = .black
    self.numberOfLines = Constants.numberOfLines
    self.lineBreakMode = .byTruncatingTail
    self.sizeToFit()
  }
}
