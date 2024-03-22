//
//  ConnectionError.swift
//  travelPlan
//
//  Created by 양승현 on 3/18/24.
//

import Foundation
import Alamofire

enum ConnectionError: LocalizedError {
  case invalidInternetConnection
  case unavailableServer
  
  var errorDescription: String? {
    switch self {
    case .invalidInternetConnection:
      NSLocalizedString("인터넷 연결이 유효하지 않습니다. 네트워크 설정을 확인하세요.", comment: "")
    case .unavailableServer:
      NSLocalizedString("서버에 연결할 수 없습니다. 나중에 다시 시도하세요.", comment: "")
    }
  }
}

// MARK: - Helpers
extension AFError {
  var mapConnectionError: ConnectionError? {
    switch self {
    case .sessionTaskFailed(let error as URLError):
      if error.code == .notConnectedToInternet {
        return .invalidInternetConnection
      }
      return nil
    case .responseValidationFailed(let reason):
      switch reason {
      case .unacceptableStatusCode(code: 404...599):
        return .unavailableServer
      default:
        return nil
      }
    default:
      return nil
    }
  }
}