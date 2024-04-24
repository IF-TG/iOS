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
                .responseData { response in
                  switch response.result {
                  case .success(let data):
                    // 일반적인 경우고, 이거마저도 header 확인해주어야한다.
                    do {
                      let responseDTO = try JSONDecoder().decode(R.self, from: data)
                      promise(.success(responseDTO))
                    } catch let error as Swift.DecodingError {
                      handleDecodingError(error, from: data, promise: promise)
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
  private func handleDecodingError<R: Decodable>(
    _ error: Swift.DecodingError,
    from data: Data,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    // TODO: - 로그 남기기 (컨텍스트, 타입 등)
    if case .dataCorrupted = error {
      handleDataCorrupedDecodingError(error, from: data, promise: promise)
    }
    
    if case .typeMismatch = error {
      let errorResponseDTO = try? JSONDecoder().decode(TourApiErrorResponseDTO.self, from: data)
    }
    
    promise(.failure(AFError.responseSerializationFailed(reason: .customSerializationFailed(error: error))))
  }
  
  private func handleDataCorrupedDecodingError<R: Decodable>(
    _ error: Swift.DecodingError,
    from data: Data,
    promise: @escaping Future<R, AFError>.Promise
  ) {
    xmlParsingService = XMLParsingService(parser: XMLParser(data: data))
    // 이떄 파서로 파싱 고고
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

  }
}
