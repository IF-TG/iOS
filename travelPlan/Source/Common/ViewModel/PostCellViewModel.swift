//
//  PostCellViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

final class PostCellViewModel {
  // MARK: - Properties
  private let postModel: PostInfo?
  
  var headerModel: PostHeaderInfo? {
    postModel?.header
  }
  
  var contentAreaModel: PostContentInfo? {
    postModel?.content
  }
  
  var footerModel: PostFooterInfo? {
    postModel?.footer
  }

  // MARK: - Initialization
  init(postModel: PostInfo?) {
    self.postModel = postModel
  }
}
