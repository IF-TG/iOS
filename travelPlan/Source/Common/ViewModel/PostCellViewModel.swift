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
  
  // MARK: - Default data(When fetched data invalid)
  var defaultHeaderModel: PostHeaderInfo {
    .init()
  }
  
  var defaultContentAreaModel: PostContentInfo {
    PostContentInfo()
  }
  
  var defaultFooterModel: PostFooterInfo {
    PostFooterInfo()
  }
  
  // MARK: - Initialization
  init(postModel: PostInfo?) {
    self.postModel = postModel
  }
}

// MARK: - Public Helpers
extension PostCellViewModel {
  
  // MARK: - Check model is valid data
  func isValidatedHeaderModel() -> Bool {
    let manager = DateValidationManager()
    guard 
      let subInfoModel = headerModel?.subInfo,
      subInfoModel.isValidatedDuration(),
      subInfoModel.isValidatedUsername(),
      subInfoModel.isValidatedYearMonthDayRange(fromDateValidationManager: manager)
    else {
      return false
    }
    return true
  }
  
  func isValidatedContentAreaModel() -> Bool {
    guard
      let contentAreaModel,
      contentAreaModel.isValidatedThumbnailImages() else {
      return false
    }
    return true
  }
  
  func isValidatedFooterModel() -> Bool {
    guard
      let footerModel,
      footerModel.isValidatedCommentCount() ||
      footerModel.isValidatedHeartCount()
    else {
      return false
    }
    return true
  }
}
