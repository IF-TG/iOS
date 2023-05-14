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
  var thumbnailImages: [UIImage]
  
  // 데이터가 유효하지 않은 경우
  init(text: String = "N/A",
       thumbnailImages: [UIImage] = [UIImage()]) {
    self.text = text
    self.thumbnailImages = thumbnailImages
  }
}

// MARK: - Public helpers
extension PostContentAreaModel {
  func isValidatedThumbnailImages() -> Bool {
    if !thumbnailImages.isEmpty { return true }
    return false
  }
}
