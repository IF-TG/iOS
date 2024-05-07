//
//  MockFirestoreImageStorage.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/4/24.
//

import Foundation
import Combine

/// 각각의 함수 호출시 성공적으로 반환합니다.
struct MockFirestoreImageStorage: ImageStorageServiceProtocol {
  func uploadImage(
    _ imageData: Data,
    type: ImageStorageServiceType
  ) -> AnyPublisher<String, any Error> {
    return Just("imagePath1")
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  func uploadImages(
    _ imageDataList: [Data],
    type: ImageStorageServiceType
  ) -> AnyPublisher<[String], any Error> {
    return Just(imageDataList.map { $0.description })
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  func fetchImage(
    _ url: String,
    type: ImageStorageServiceType
  ) -> AnyPublisher<Data, any Error> {
    return Just("이미지 데이터 성공적으로 받음".data(using: .utf8)!)
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  func fetchImages(
    _ urls: [String],
    type: ImageStorageServiceType
  ) -> AnyPublisher<[Data], any Error> {
    return Just(urls.compactMap { $0.data(using: .utf8) })
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  func deleteImage(
    _ url: String,
    type: ImageStorageServiceType
  ) -> AnyPublisher<Void, any Error> {
    return Just(())
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  func deleteImages(
    _ urls: [String],
    type: ImageStorageServiceType
  ) -> AnyPublisher<Void, any Error> {
    return Just(())
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
