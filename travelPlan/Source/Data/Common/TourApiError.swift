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
    switch code {
    case "01": self = .applicationError
    case "02": self = .dbError
    case "03": self = .noDataError
    case "04": self = .httpError
    case "05": self = .serviceTimeoutError
    case "10": self = .invalidRequestParameterError
    case "11": self = .noMandatoryRequestParametersError
    case "12": self = .noOpenAPIServiceError
    case "20": self = .serviceAccessDeniedError
    case "21": self = .temporarilyDisableTheServiceKeyError
    case "22": self = .limitedNumberOfServiceRequestsExceedsError
    case "30": self = .serviceKeyIsNotRegisteredError
    case "31": self = .deadlineHasExpiredError
    case "32": self = .unregisteredIPError
    case "33": self = .unsignedCallError
    default: self = .unknownError
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
