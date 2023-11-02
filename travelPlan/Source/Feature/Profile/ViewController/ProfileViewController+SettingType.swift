//
//  SettingType.swift
//  travelPlan
//
//  Created by 양승현 on 11/3/23.
//

import UIKit

@frozen enum SettingType: String, CaseIterable {
  case accountSetting = "계정 관리"
  case myInformation = "내 정보"
  
  case activitySetting = "활동 관리"
  case myPosts = "내가 작성한 후기 글"
  case myActivity = "내 활동"
  case blockList = "차단 목록"
  
  case service = "서비스"
  case operationGuide = "이용안내"
  case customerService = "고객센터"
  
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