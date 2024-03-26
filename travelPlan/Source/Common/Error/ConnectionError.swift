//
//  ConnectionError.swift
//  travelPlan
//
//  Created by 양승현 on 3/18/24.
//

import Foundation
import Combine
import Alamofire

/// A레포지토리에서 발생된 에러를 C유즈케이스 에러로 변환해서 하위 스트림에게 방출한다면 이는 문제가 됩니다.
/// A레포지토리를 D유즈케이스에서 사용할 때 D유즈케이스에러가 존재한다면 대응이 불가능합니다,,,
///
/// AFError에서 발생될 수 있는 에러들을 다음과 같이 최대한 축소시켰습니다.
/// 예를들어 디코딩 에러가 발생될 경우 클라이언트 에러로 간주합니다.
/// 레포지토리에서 방출된 에러타입은 Error로 추상화 하면서도 AFError가 발생될 경우 추상화해서 반환시킬 때 Presentation layer에서 error의 원인을 파악할때 AFError의 여러 enum case의 축소화된 이 에러로 짐작후 대처할 수 있습니다.
enum ConnectionError: LocalizedError {
  case invalidInternetConnection
  case unavailableServer
  case unexpectedError(error: Error)
  case clientError
  
  var errorDescription: String {
    switch self {
    case .invalidInternetConnection:
      NSLocalizedString("인터넷 연결이 유효하지 않습니다. 네트워크 설정을 확인하세요.", comment: "")
    case .unavailableServer:
      NSLocalizedString("서버에 연결할 수 없습니다. 나중에 다시 시도하세요.", comment: "")
    case .clientError:
      NSLocalizedString("클라이언트에서 에러가 발생했습니다.", comment: "")
    case .unexpectedError(let error):
      NSLocalizedString("알 수 없는 에러가 발생됬습니다.\n:\(error.localizedDescription)", comment: "")
    }
  }
}

// MARK: - AFError extension
extension AFError {
  var asConnectionError: ConnectionError {
    switch self {
    case .sessionTaskFailed(let error as URLError):
      if error.code == .notConnectedToInternet {
        return .invalidInternetConnection
      }
      return .unexpectedError(error: self)
    case .responseValidationFailed(let reason):
      switch reason {
      case .unacceptableStatusCode(code: 500...599):
        return .unavailableServer
      case .unacceptableStatusCode(code: 404...499):
        return .clientError
      default:
        return .unexpectedError(error: self)
      }
    default:
      return .unexpectedError(error: self)
    }
  }
}

// MARK: - Publisher extension
extension Publisher where Self.Failure == AFError {
  func mapConnectionError<E: Error>(
    _ transform: @escaping (Self.Failure) -> E
  ) -> Publishers.MapError<Self, Error> {
    return self.mapError { error in
      error.asConnectionError
    }
  }
  
  func mapConnectionError() -> Publishers.MapError<Self, Error> {
    return self.mapError { $0.asConnectionError }
  }
}
