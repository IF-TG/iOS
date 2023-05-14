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
