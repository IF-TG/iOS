//
//  PostHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

protocol PostHeaderViewDelegate: BaseProfileAreaViewDelegate { }

final class PostHeaderView: BaseProfileAreaView {
  
  // MARK: - Properteis
  private let postInfoView = PostHeaderContentView()
  
  weak var delegate: PostHeaderViewDelegate?
  
  override var baseDelegate: BaseProfileAreaViewDelegate? {
    get {
      return delegate
    } set {
      delegate = newValue as? PostHeaderViewDelegate
    }
  }
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    super.init(
      frame: frame,
      contentView: postInfoView,
      profileLayoutInfo: .small(.centerY))
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

// MARK: - Helpers
extension PostHeaderView {
  func configure(with data: PostHeaderInfo?) {
    super.configure(with: data?.imageURL)
    postInfoView.configure(with: data?.contentInfo)
  }
}
