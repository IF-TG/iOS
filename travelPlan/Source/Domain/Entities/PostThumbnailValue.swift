//
//  PostThumbnailValue.swift
//  travelPlan
//
//  Created by 양승현 on 11/26/23.
//

import Foundation

/// Feed탭의 포스트(사용자 여행 경험 후기)글은 1~5개의 이미지를 갖습니다.
@propertyWrapper
struct PostThumbnailValue {
  private let minThumbanils = 1
  private let maxThumbnails = 5
  private var value: Int
  var wrappedValue: Int {
    get { return value }
    set {
      if (minThumbanils...maxThumbnails).contains(newValue) {
        value = newValue
      } else {
        print("DEBUG: 올바르지 않은 값이 들어갔습니다.")
        value = minThumbanils
      }
    }
  }
  
  init(value: Int) {
    self.value = (minThumbanils...maxThumbnails).contains(value) ? value : 1
  }
}
