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
  
  private let xmlParsingService: XMLParsingServiceProtocol
  
  private var subscriptions = Set<AnyCancellable?>()
  
  private let timeout: Double
  
  // MARK: - Lifecycle
  init(
    session: Session = .default,
    xmlParsingService: XMLParsingServiceProtocol,
    timeout: Double = 30
  ) {
    self.session = session
    self.timeout = timeout
    self.xmlParsingService = xmlParsingService
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
  private func handleDecodingError<R: Decodable>(
    _ error: Swift.DecodingError,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    // TODO: - 로그 남기기
    if case .dataCorrupted(let context) = error {
      handleDataCorrupedDecodingError(error, promise: promise)
    }
    
    if case .typeMismatch(let type, let context) = error {
      // TODO: - 그 3개 타입 만들어서 비교해야함.
      promise(.failure(.explicitlyCancelled))
    }
    
    promise(.failure(AFError.responseSerializationFailed(reason: .customSerializationFailed(error: error))))
  }
  
  private func handleDataCorrupedDecodingError<R: Decodable>(
    _ error: Swift.DecodingError,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    // TODO: - 로그 남기기
    if case .dataCorrupted(let context) = error {
      // 이떄 파서로 파싱 고고
      let xmlParsingSubscription = xmlParsingService
        .xmlParserNotifier
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(
              AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
          }
        } receiveValue: { attributes in
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
    }
  }
}
