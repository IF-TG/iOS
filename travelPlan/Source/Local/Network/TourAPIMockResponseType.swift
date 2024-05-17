//
//  TourAPIMockResponseType.swift
//  travelPlan
//
//  Created by SeokHyun on 5/17/24.
//

import Foundation

@frozen
enum TourAPIMockResponseType {
  /// 소개정보조회
  case introdution(TourType)
  
  
  
  
  // MARK: - Properties
  private var filePath: String {
    switch self {
    case .introdution(let tourType):
      [TourType.attraction: "mock_tourAPI_introductionInfo_attraction",
       TourType.festival: "mock_tourAPI_introductionInfo_festival",
       TourType.shopping: "mock_tourAPI_introductionInfo_shopping",
       TourType.cultureFacility: "mock_tourAPI_introductionInfo_cultureFacility",
       TourType.leports: "mock_tourAPI_introductionInfo_leports",
       TourType.restaurant: "mock_tourAPI_introductionInfo_restaurant",
       TourType.accommodation: "mock_tourAPI_introductionInfo_accommodation",
       TourType.course: "mock_tourAPI_introductionInfo_course"
      ][tourType]!
    }
  }
  
  /// case에 대한 json 디렉터리 -> Data로 불러올 때 사용합니다.
  var mockDataLoader: Data {
    guard let path = Bundle.main.path(forResource: filePath, ofType: "json") else {
      return Data()
    }
    guard let jsonStr = try? String(contentsOfFile: path) else {
      return Data()
    }
    return jsonStr.data(using: .utf8) ?? Data()
  }
}
