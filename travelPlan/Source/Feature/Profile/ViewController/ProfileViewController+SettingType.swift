//
//  SettingType.swift
//  travelPlan
//
//  Created by 양승현 on 11/3/23.
//

import UIKit.UIColor

@frozen enum SettingType: String, CaseIterable {
  // index 0
  case accountSetting = "계정 관리"
  case myInformation = "내 정보"
  
  // index = 2
  case activitySetting = "활동 관리"
  case myPosts = "내가 작성한 후기 글"
  case myActivity = "내 활동"
  case blockList = "차단 목록"
  
  // index = 6
  case service = "서비스"
  case operationGuide = "이용안내"
  case customerService = "고객센터"
  
  // index = 0
  case versionInformation = "버전정보"
  
  var fontType: UIFont.Pretendard {
    switch self {
    case .accountSetting, .activitySetting, .service:
      return .semiBold_600(fontSize: 16)
    case .versionInformation:
      return .regular_400(fontSize: 13)
    default:
      return .medium_500(fontSize: 14)
    }
  }
  
  var index: Int {
    switch self {
    case .accountSetting: return 0
    case .myInformation: return 1
    case .activitySetting: return 2
    case .myPosts: return 3
    case .myActivity: return 4
    case .blockList: return 5
    case .service: return 6
    case .operationGuide: return 7
    case .customerService: return 8
    case .versionInformation: return 9
    }
  }
  
  var section: Int {
    switch self {
    case .accountSetting,
         .myInformation:
      return 0
    case .activitySetting,
         .myPosts,
         .myActivity,
         .blockList:
      return 1
    case .service,
         .operationGuide,
          .customerService:
      return 2
    case .versionInformation:
      return 3
    }
  }
  
  var fontColor: UIColor {
    switch self {
    case .accountSetting, .activitySetting, .service, .versionInformation:
      return .yg.gray6
    default:
      return .yg.gray5
    }
  }
  
  var lineHeight: CGFloat {
    30
  }
}
