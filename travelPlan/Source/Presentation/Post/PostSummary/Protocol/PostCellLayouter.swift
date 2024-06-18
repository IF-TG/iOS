//
//  PostCellLayouter.swift
//  travelPlan
//
//  Created by 양승현 on 6/1/24.
//

import UIKit

protocol PostCellLayouter: LayoutSupport {
  var postView: BasePostView { get }
}

extension PostCellLayouter where Self: UICollectionViewCell {
  func addSubviews() {
    contentView.addSubview(postView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      postView.topAnchor.constraint(equalTo: contentView.topAnchor),
      postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}
