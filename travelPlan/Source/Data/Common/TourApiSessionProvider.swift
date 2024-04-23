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
  let session: Session
  private let timeout: Double
  init(session: Session = .default, timeout: Double = 30) {
    self.session = session
    self.timeout = timeout
    session.sessionConfiguration.timeoutIntervalForRequest = timeout
  }
}

// MARK: - Sessionable
extension TourApiSessionProvider: Sessionable {
  /// Tour API에서 제공하는 json의 벨류는 \n이 존재할 수 있습니다. json에서 value에 escape문자는 parsing을 방해한다고 합니다...
  /// 역시나 JSONDecoder을 사용할떄 init(from:) 의 컨테이너에서 특정 타입을 디코딩할 때 에러가 던져집니다.
  /// JSONSerialization 등을 사용해도 에러가 던져지는건 마찬가지입니다. JSON에서 escape character
  ///   중 특히 \n을 사용해 깔끔히 보여 지게 하기위해 사용되는것 같기 때문입니다.
  /// swift에선 \\n을 사용한다면 json value에서 사용될 수 있지만.. \n이 온다는 사실 ㅠㅠ
  /// 한가지 해결 책은 \n -> \\n으로 바꾸려고햇으나 이 또한 escape 문자로 해당되서 아예 escape를 제거하는 방식으로 구현하기로 했습니다...
  /// \n 뿐 아니라 다른 escape character가 온다면 마찬가지로 제거해야합니다.
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
                    guard
                      let editedDataWithoutEscapeCharacter = String(data: data, encoding: .utf8)?
                      .replacingOccurrences(of: "\n", with: "")
                      .data(using: .utf8)
                    else {
                      promise(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                      return
                    }
                    do {
                      let responseDTO = try JSONDecoder().decode(R.self, from: editedDataWithoutEscapeCharacter)
                      promise(.success(responseDTO))
                    } catch {
                      promise(
                        .failure(AFError.responseSerializationFailed(
                          reason: .customSerializationFailed(error: error))))
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
