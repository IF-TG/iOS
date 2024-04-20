//
//  APIManager.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

final class APIManager {
  static let shared = APIManager()
  
  private init() {}
  
  func apiKey(with type: APIKeyType) -> String? {
    guard
      let file = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
      let resource = NSDictionary(contentsOfFile: file),
      let key = resource[type.path] as? String
    else {
      print("\(type.path) api key얻어오는것을 실패했습니다.")
      return nil
    }
    return key
  }
}

extension APIManager {
  @frozen enum APIKeyType {
    case tourAPI
    
    var path: String {
      switch self {
      case .tourAPI:
        return "TourAPI_ServiceKey"
      }
    }
  }
}
