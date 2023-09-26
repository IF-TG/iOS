//
//  PostHeaderProfileAndInfoView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

final class PostHeaderProfileAndInfoView: BaseLeftRoundProfileAreaView {
  struct Model {
    let title: String
    let image: UIImage?
    let subInfo: PostHeaderSubInfoModel
    
    // 데이터가 존재하지 않을 경우
    init(title: String = "제목 없음",
         image: UIImage? = nil,
         subInfo: PostHeaderSubInfoModel = PostHeaderSubInfoModel()) {
      self.title = title
      self.image = image
      self.subInfo = subInfo
    }
  }

  // MARK: - Properteis
  private let postInfoView = PostHeaderInfoView()
  
  var profileDelegate: BaseLeftRoundProfileAreaViewDelegate? {
    get {
      super.delegate
    }
    set {
      super.delegate = newValue
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
  
  // MARK: - Helper
  func configure(with data: Model?) {
    super.configure(with: data?.image)
    postInfoView.configure(title: data?.title, subInfoData: data?.subInfo)
  }
}
