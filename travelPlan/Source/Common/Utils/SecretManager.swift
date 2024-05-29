//
//  SecretManager.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

final class SecretManager {
  static let shared = SecretManager()
  
  private init() {}
  
  func get(with type: SecretType) -> String? {
    guard let key = Bundle.main.object(forInfoDictionaryKey: type.path) as? String else {
      print("\(type.path) api key얻어오는것을 실패했습니다.")
      return nil
    }
    return key
  }
}

extension SecretManager {
  @frozen enum SecretType {
    case tourAPI
    case appsFlyerDevKey
    case appleAppId
    
    var path: String {
      switch self {
      case .tourAPI:
        return "TourAPI_ServiceKey"
      case .appsFlyerDevKey:
        return "AppsFlyerDevKey"
      case .appleAppId:
        return "AppleAppId"
      }
    }
  }
}
