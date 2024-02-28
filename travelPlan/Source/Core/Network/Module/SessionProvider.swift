//
//  SessionProvider.swift
//  travelPlan
//
//  Created by 양승현 on 10/14/23.
//

import Alamofire
import Combine
import Foundation

final class SessionProvider {
  let session: Session
  private let timeout: Double
  init(session: Session = .default, timeout: Double = 30) {
    self.session = session
    self.timeout = timeout
    session.sessionConfiguration.timeoutIntervalForRequest = timeout
  }
}

// MARK: - Sessionable
extension SessionProvider: Sessionable {
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
          .responseDecodable(of: R.self) { response in
            switch response.result {
            case .success(let data):
              return promise(.success(data))
            case .failure(let error):
              return promise(.failure(error))
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
