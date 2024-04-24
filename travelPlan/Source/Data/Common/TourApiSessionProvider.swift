//
//  TourApiSessionProvider.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Alamofire
import Combine
import Foundation

final class TourApiSessionProvider {
  // MARK: - Properties
  private let session: Session
  
  var xmlParsingService: XMLParsingServiceProtocol?
  
  private var subscriptions = Set<AnyCancellable?>()
  
  private let timeout: Double
  
  // MARK: - Lifecycle
  init(
    session: Session = .default,
    timeout: Double = 30
  ) {
    self.session = session
    self.timeout = timeout
    session.sessionConfiguration.timeoutIntervalForRequest = timeout
  }
}

// MARK: - Sessionable
extension TourApiSessionProvider: Sessionable {
  func request<R, E>(endpoint: E) -> Future<R, AFError>
  where R: Decodable,
        E: NetworkInteractionable,
        R == E.ResponseDTO {
          return Future<R, AFError> { [weak self] promise in
            do {
              guard let session = self?.session else { return promise(.failure(.sessionInvalidated(error: nil)))}
              let request = try endpoint.makeRequest(from: session)
              request
                .validate(statusCode: 200...299)
                .responseData { [weak self] response in
                  switch response.result {
                  case .success(let data):
                    do {
                      let responseDTO = try JSONDecoder().decode(R.self, from: data)
                      promise(.success(responseDTO))
                    } catch let error as Swift.DecodingError {
                      self?.handleDecodingError(error, from: data, promise: promise)
                    } catch {
                      promise(.failure(
                        AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))))
                    }
                  case .failure(let error):
                    promise(.failure(error))
                  }
                }
            } catch let err as AFError {
              return promise(.failure(err))
            } catch {
              return promise(.failure(.createURLRequestFailed(error: error)))
            }
          }
        }
}

// MARK: - Private Helpers
extension TourApiSessionProvider {
  // TODO: - 로그 남기기 (컨텍스트, 타입 등)
  private func handleDecodingError<R: Decodable>(
    _ error: Swift.DecodingError,
    from data: Data,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    if case .dataCorrupted = error {
      handleErrorForCorrupedDecoding(error, from: data, promise: promise)
    } else if case .typeMismatch = error {
      handleErrorForTypeMismatch(error, from: data, promise: promise)
    } else {
      /// 디코딩 에러
      promise(.failure(AFError.responseSerializationFailed(reason: .customSerializationFailed(error: error))))
    }
  }
  
  /// response data가 JSON type이 아닌 경우
  private func handleErrorForCorrupedDecoding<R: Decodable>(
    _ error: Swift.DecodingError,
    from data: Data,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    xmlParsingService = XMLParsingService(parser: XMLParser(data: data))
    let xmlParsingSubscription = xmlParsingService?
      .xmlParserNotifier
      .sink { [weak self] completion in
        self?.xmlParsingService = nil
        if case .failure(let error) = completion {
          promise(.failure(
            AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
        }
      } receiveValue: { [weak self] attributes in
        self?.xmlParsingService = nil
        if let errorCode = attributes["returnReasonCode"],
           let tourApiError = TourAPIError(code: errorCode) {
          promise(.failure(
            AFError.responseSerializationFailed(reason: .decodingFailed(error: tourApiError))))
        }
        let unexpectedError = TourAPIError.unexpectedDecodingErrorFromPublicDataPortal
        promise(.failure(
          AFError.responseSerializationFailed(reason: .decodingFailed(error: unexpectedError))))
      }
    subscriptions.insert(xmlParsingSubscription)
    xmlParsingService?.parse()
  }
  
  /// response data json 형식이 R타입과 맞지 않는 경우
  /// TourApiErrorResponseDTO 에러인지 검증
  private func handleErrorForTypeMismatch<R: Decodable>(
    _ error: Swift.DecodingError,
    from data: Data,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    if let errorResponseDTO = try? JSONDecoder().decode(TourApiErrorResponseDTO.self, from: data) {
      let tourAPIError = TourAPIError(code: errorResponseDTO.resultCode) ?? .publicDataPortalError(.unknownError)
      let reason = AFError.ResponseSerializationFailureReason.customSerializationFailed(error: tourAPIError)
      promise(.failure(AFError.responseSerializationFailed(reason: reason)))
    }
  }
}
