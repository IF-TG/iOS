//
//  PostCellViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

struct PostCellViewModel {
  // MARK: - Properties
  private let postModel: PostModel
  
  var headerModel: PostHeaderModel {
      postModel.header
  }
  
  var contentAreaModel: PostContentAreaModel {
    postModel.content
  }
  
  var footerModel: PostFooterModel {
    postModel.footer
  }
  
  // MARK: - Default data (데이터 유효하지 않은 경우 기본 문구 대체)
  var defaultHeaderModel: PostHeaderModel {
    PostHeaderModel()
  }
  
  var defaultContentAreaModel: PostContentAreaModel {
    PostContentAreaModel()
  }
  
  var defaultFooterModel: PostFooterModel {
    PostFooterModel()
  }
  
  // MARK: - Initialization
  init(postModel: PostModel) {
    self.postModel = postModel
  }
}

// MARK: - Public Helpers
extension PostCellViewModel {
  
  // MARK: - Check model is valid data
  func isValidatedHeaderModel() -> Bool {
    let subInfoModel = headerModel.subInfo
    let manager = DateValidationManager()
    guard headerModel.isValidated() else {
      return false
    }
    guard subInfoModel.isValidatedDuration(),
          subInfoModel.isValidatedUsername(),
          subInfoModel.isValidatedYearMonthDayRange(
            fromDateValidationManager: manager)
    else {
      return false
    }
    return true
  }
  
  func isValidatedContentAreaModel() -> Bool {
    guard contentAreaModel.isValidatedThumbnailImages() else {
      return false
    }
    return true
  }
  
  func isValidatedFooterModel() -> Bool {
    guard
      footerModel.isValidatedCommentCount() ||
      footerModel.isValidatedHeartCount()
    else {
      return false
    }
    return true
  }
}

// MARK: - Helpers
extension PostCellViewModel {
  private func calculateDynamicLabelHeight(
    fromSuperView collectionView: UICollectionView
  ) -> CGFloat {
    let labelWidth = collectionView.bounds.width - (
      PostContentAreaView.Constant.Text.Spacing.leading + PostContentAreaView.Constant.Text.Spacing.trailing)
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 1))
    label.numberOfLines = 3
    label.font = UIFont.systemFont(
      ofSize: PostContentAreaView.Constant.Text.textSize)
    label.lineBreakMode = PostContentAreaView
      .Constant.Text.lineBreakMode
    label.text = contentAreaModel.text
    label.sizeToFit()
    return label.bounds.height
  }
  
}
