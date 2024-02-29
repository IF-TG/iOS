//
//  NetworkError.swift
//  travelPlan
//
//  Created by 양승현 on 3/1/24.
//

import Foundation

enum NetworkError {
  /// 클라이언트에서 발생
  enum RequestError {
    case invalidRequest(URLRequest)
    case encodingError(Swift.EncodingError)
    case other(Swift.Error)
  }
  enum ServerError {
    case timeout
    case noInternetConnect
    case decodingError(Swift.DecodingError)
    case internalServerProblem
    case other(statusCode: Int, response: HTTPURLResponse)
  }
  
  case requestError(RequestError)
  case serverError(ServerError)
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .requestError(let error):
      return describeRequestError(for: error)
    case .serverError(let error):
      return describeServerError(for: error)
    }
  }
  
  private func describeRequestError(for error: RequestError) -> String {
    switch error {
    case .invalidRequest(let request):
      return "DEBUG: Invalid request: \(request.description)"
    case .encodingError(let encodingError):
      return "DEBUG: Encoding error: \(encodingError.localizedDescription)"
    case .other(let error):
      return "DEBUG: Other reqeust error: \(error.localizedDescription)"
    }
  }
  
  private func describeServerError(for error: ServerError) -> String {
    switch error {
    case .timeout:
      return "DEBUG: Server timeout"
    case .noInternetConnect:
      return "DEBUG: No internet connection"
    case .internalServerProblem:
      return "DEBUG: Internal server problem"
    case .decodingError(let error):
      return "Decoding error: \(error.localizedDescription)"
    case .other(statusCode: let statusCode, response: let response):
      return "DEBUG: other error: Status code \(statusCode), Response: \(response.description)"
    }
  }
}
