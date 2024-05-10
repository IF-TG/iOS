//
//  ImageDataFetcher.swift
//  travelPlan
//
//  Created by SeokHyun on 5/9/24.
//

import Foundation
import Combine
import Alamofire

class ImageDataFetcher {
  func request(imageURL: String, queue: DispatchQueue) -> AnyPublisher<Data, AFError> {
    return Future { promise in
      AF.request(imageURL)
        .validate(statusCode: 200..<300)
        .responseData(queue: queue) { response in
          switch response.result {
          case .success(let data):
            promise(.success(data))
          case .failure(let error):
            promise(.failure(error))
          }
        }
    }
    .eraseToAnyPublisher()
  }
}
