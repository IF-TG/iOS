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
  private let session: URLSession
  init(session: URLSession = .shared) {
    self.session = session
  }
}

// MARK: - Sessionable
extension SessionProvider: Sessionable {
  func request<R, E>(endpoint: E) -> Future<R, AFError>
  where R: Decodable,
        E: NetworkInteractionable,
        E.Params: Encodable {
    return Future<R, AFError> { promise in
      do {
        let request = try endpoint.makeRequest()
        request.validate()
        request.responseDecodable(of: R.self) { response in
          switch response.result {
          case .success(let data):
            return promise(.success(data))
          case .failure(let error):
            return promise(.failure(error))
          }
        }
        return promise(.failure(.explicitlyCancelled))
      } catch let err as AFError {
        return promise(.failure(err))
      } catch {
        print("DEBUG: Unexpected Error ", error.localizedDescription)
      }
    }
  }
}
