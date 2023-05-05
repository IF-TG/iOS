//
//  TabBarCase.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

enum TabBarCase: String {
  case feed
  case search
  case plan
  case heart
  case profile
  
  var title: String {
    switch self {
    case .feed: return "피드"
    case .search: return "검색"
    case .plan: return "플랜"
    case .heart: return "찜"
    case .profile: return "프로필"
    }
  }
}
