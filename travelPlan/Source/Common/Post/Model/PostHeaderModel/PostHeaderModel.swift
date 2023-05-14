//
//  PostHeaderModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

enum ValidationError: Error {
  case emptyTitle
  case missingImage
}

struct PostHeaderModel {
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

// MARK: - Helpers
extension PostHeaderModel {
  func isValidated() -> Bool {
    do {
      try validate()
      return true
    } catch {
      return false
    }
  }
  
  private func validate() throws {
    if title.isEmpty {
      throw ValidationError.emptyTitle
    }
    if image == nil {
      throw ValidationError.missingImage
    }
  }
}
