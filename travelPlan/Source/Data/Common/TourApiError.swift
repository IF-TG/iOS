//
//  TourApiError.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

@frozen enum TourAPIError: LocalizedError {
  case publicDataPortalError(PublicDataPortalInTourAPIError)
  case tourAPIProviderInstitutionError(TourAPIProviderInstitutionError)
  
  /// Public Data Portal의 에러를 데이터로 받았을 때 알 수 없는 디코딩 에러 발생된 경우
  case unexpectedDecodingErrorFromPublicDataPortal
  
  /// 성공적으로 반환받은 데이터(TourApiCommonResponseDTO)의 response header에서 TourAPIError를 생성할 수 없는,
  ///   국문에서 정의되지 않은 errorCode를 받은 경우
  case unexpectedErrorFromSuccessfulResponseData(String)
  
  /// item 배열에 element가 존재하지 않는 경우
  case noItem
}

/// 공공데이터 포털 에러
@frozen enum PublicDataPortalInTourAPIError: LocalizedError {
  case applicationError
  case httpError
  case noOpenAPIServiceError
  case serviceAccessDeniedError
  case limitedNumberOfServiceRequestsExceedsError
  case serviceKeyIsNotRegisteredError
  case deadlineHasExpiredError
  case unregisteredIPError
  case unknownError
  
  init?(code: String) {
    let errorDict = [
      "01": .applicationError,
      "04": .httpError,
      "12": .noOpenAPIServiceError,
      "20": .serviceAccessDeniedError,
      "22": .limitedNumberOfServiceRequestsExceedsError,
      "30": .serviceKeyIsNotRegisteredError,
      "31": .deadlineHasExpiredError,
      "32": .unregisteredIPError,
      "99": .unknownError
    ] as [String: PublicDataPortalInTourAPIError]
    
    if let errorType = errorDict[code] {
      self = errorType
    } else {
      return nil
    }
  }
  
  var errorDescription: String? {
    switch self {
    case .applicationError:
      return "An error occurred in the application."
    case .httpError:
      return "An HTTP error occurred."
    case .noOpenAPIServiceError:
      return "No OpenAPI service error."
    case .serviceAccessDeniedError:
      return "Service access denied error."
    case .limitedNumberOfServiceRequestsExceedsError:
      return "The limited number of service requests exceeds error."
    case .serviceKeyIsNotRegisteredError:
      return "The service key is not registered error."
    case .deadlineHasExpiredError:
      return "The deadline has expired error."
    case .unregisteredIPError:
      return "Unregistered IP error."
    case .unknownError:
      return "An unknown error occurred."
    }
  }

}

/// 제공기관 에러
@frozen enum TourAPIProviderInstitutionError: LocalizedError {
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
  
  init?(code: String) {
    let errorMap: [String: TourAPIProviderInstitutionError] = [
      "01": .applicationError,
      "02": .dbError,
      "03": .noDataError,
      "04": .httpError,
      "05": .serviceTimeoutError,
      "10": .invalidRequestParameterError,
      "11": .noMandatoryRequestParametersError,
      "12": .noOpenAPIServiceError,
      "20": .serviceAccessDeniedError,
      "21": .temporarilyDisableTheServiceKeyError,
      "22": .limitedNumberOfServiceRequestsExceedsError,
      "30": .serviceKeyIsNotRegisteredError,
      "31": .deadlineHasExpiredError,
      "32": .unregisteredIPError,
      "33": .unsignedCallError,
      "99": .unknownError
    ]
    
    if let errorType = errorMap[code] {
      self = errorType
    } else {
      return nil
    }
  }
  
  var errorDescription: String? {
    switch self {
    case .applicationError: return "An error occurred in the application."
    case .dbError: return "A database error occurred."
    case .noDataError: return "No data available error."
    case .httpError: return "An HTTP error occurred."
    case .serviceTimeoutError: return "Service timeout error."
    case .invalidRequestParameterError: return "Invalid request parameter error."
    case .noMandatoryRequestParametersError: return "No mandatory request parameters error."
    case .noOpenAPIServiceError: return "No OpenAPI service error."
    case .serviceAccessDeniedError: return "Service access denied error."
    case .temporarilyDisableTheServiceKeyError: return "Service key temporarily disabled error."
    case .limitedNumberOfServiceRequestsExceedsError: return "The limited number of service requests exceeds error."
    case .serviceKeyIsNotRegisteredError: return "The service key is not registered error."
    case .deadlineHasExpiredError: return "The deadline has expired error."
    case .unregisteredIPError: return "Unregistered IP error."
    case .unsignedCallError: return "Unsigned call error."
    case .unknownError: return "An unknown error occurred."
    }
  }

}
