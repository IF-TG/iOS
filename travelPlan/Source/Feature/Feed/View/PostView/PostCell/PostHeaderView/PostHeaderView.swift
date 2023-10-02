//
//  PostHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

protocol PostHeaderViewDelegate: BaseProfileAreaViewDelegate { }

final class PostHeaderView: BaseProfileAreaView {
  struct Model {
    let title: String
    let image: UIImage?
    let subInfo: PostHeaderSubInfoModel
    
    init(
      title: String = "제목 없음",
      image: UIImage? = nil,
      subInfo: PostHeaderSubInfoModel = PostHeaderSubInfoModel()
    ) {
      self.title = title
      self.image = image
      self.subInfo = subInfo
    }
  }
  
  // MARK: - Properteis
  private let postInfoView = PostHeaderInfoView()
  
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
  func configure(with data: Model?) {
    super.configure(with: data?.image)
    postInfoView.configure(title: data?.title, subInfoData: data?.subInfo)
  }
}
