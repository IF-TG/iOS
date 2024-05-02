//
//  PostReportType.swift
//  travelPlan
//
//  Created by 양승현 on 4/7/24.
//

import Foundation

@frozen enum PostReportType: CaseIterable {
  case inaccurateInformation
  case personalInformationExposure
  case spamOrRepetitiveContent
  case vulgarOrAbusiveLanguage
  case obsceneContent
  case harmfulToMinors
  case stopRequest
  
  var toKorean: String {
    return switch self {
    case .inaccurateInformation:
      "부정확한 정보입니다."
    case .personalInformationExposure:
      "개인정보 노출을 합니다."
    case .spamOrRepetitiveContent:
      "스팸/도배글 입니다."
    case .vulgarOrAbusiveLanguage:
      "심한 욕설/비방 내용입니다."
    case .obsceneContent:
      "음란물입니다."
    case .harmfulToMinors:
      "청소년 유해물입니다."
    case .stopRequest:
      "그만두기"
    }
  }
}
