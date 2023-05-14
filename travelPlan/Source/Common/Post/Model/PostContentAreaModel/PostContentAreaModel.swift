//
//  PostContentAreaModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//
import UIKit

struct PostContentAreaModel {
  // post thumbnail 글 내용
  var text: String

  // TumbnailModel
  var thumbnailImages: [UIImageView]
  
  var thumbnailType: PostThumbnailType {
    return PostThumbnailType(fromInt: thumbnailImages.count)
  }
}

extension PostContentAreaModel {
  func isValidatedThumbnailImages() -> Bool {
    if !thumbnailImages.isEmpty { return true }
    return false
  }
}
