//
//  TourApiError.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

@frozen enum TourAPIError: LocalizedError {
  case applicationError
  case dbError
  case noDataError
  case httpError
  case serviceTimeoutError
  case invalidRequestParameterError
  case noMandatoryRequestParametersError
  case noOpenAPIServiceError
  case serviceAccessDeniedError
  case temporarilyDisableTheServiceKeyError
  case limitedNumberOfServiceRequestsExceedsError
  case serviceKeyIsNotRegisteredError
  case deadlineHasExpiredError
  case unregisteredIPError
  case unsignedCallError
  case unknownError
  
  init(code: String) {
    let errorMap: [String: TourAPIError] = [
      "0001": .applicationError,
      "0002": .dbError,
      "0003": .noDataError,
      "0004": .httpError,
      "0005": .serviceTimeoutError,
      "0010": .invalidRequestParameterError,
      "0011": .noMandatoryRequestParametersError,
      "0012": .noOpenAPIServiceError,
      "0020": .serviceAccessDeniedError,
      "0021": .temporarilyDisableTheServiceKeyError,
      "0022": .limitedNumberOfServiceRequestsExceedsError,
      "0030": .serviceKeyIsNotRegisteredError,
      "0031": .deadlineHasExpiredError,
      "0032": .unregisteredIPError,
      "0033": .unsignedCallError
    ]
    
    if let errorType = errorMap[code] {
      self = errorType
    } else {
      self = .unknownError
    }
  }
  
  var errorDescription: String? {
    switch self {
    case .applicationError: return "APPLICATION_ERROR"
    case .dbError: return "DB_ERROR"
    case .noDataError: return "NODATA_ERROR"
    case .httpError: return "HTTP_ERROR"
    case .serviceTimeoutError: return "SERVICETIMEOUT_ERROR"
    case .invalidRequestParameterError: return "INVALID_REQUEST_PARAMETER_ERROR"
    case .noMandatoryRequestParametersError: return "NO_MANDATORY_REQUEST_PARAMETERS_ERROR"
    case .noOpenAPIServiceError: return "NO_OPENAPI_SERVICE_ERROR"
    case .serviceAccessDeniedError: return "SERVICE_ACCESS_DENIED_ERROR"
    case .temporarilyDisableTheServiceKeyError: return "TEMPORARILY_DISABLE_THE_SERVICEKEY_ERROR"
    case .limitedNumberOfServiceRequestsExceedsError: return "LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR"
    case .serviceKeyIsNotRegisteredError: return "SERVICE_KEY_IS_NOT_REGISTERED_ERROR"
    case .deadlineHasExpiredError: return "DEADLINE_HAS_EXPIRED_ERROR"
    case .unregisteredIPError: return "UNREGISTERED_IP_ERROR"
    case .unsignedCallError: return "UNSIGNED_CALL_ERROR"
    case .unknownError: return "UNKNOWN_ERROR"
    }
  }
}
