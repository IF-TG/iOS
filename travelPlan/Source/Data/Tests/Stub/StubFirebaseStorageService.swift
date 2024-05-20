//
//  StubFirebaseStorageService.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/20/24.
//

import Foundation
import Combine
@testable import travelPlan

final class StubFirebaseStorageService: ImageStorageServiceProtocol {
  private let mockURL = "https:gs://yeoga-cebaf.appspot.com/.../"
  func uploadImage(
    _ imageData: Data,
    type: travelPlan.ImageStorageServiceType
  ) -> AnyPublisher<String, any Error> {
    return Just(mockURL).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func uploadImages(
    _ imageDataList: [Data],
    type: travelPlan.ImageStorageServiceType
  ) -> AnyPublisher<[String], any Error> {
    return Just((0..<imageDataList.count).map { _ in mockURL }).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchImage(
    _ url: String,
    type: travelPlan.ImageStorageServiceType
  ) -> AnyPublisher<Data, any Error> {
    return Just("이미지".data(using: .utf8)!).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchImages(
    _ urls: [String],
    type: travelPlan.ImageStorageServiceType
  ) -> AnyPublisher<[Data], any Error> {
    let imageDataList = (0..<urls.count).map { _ in return "이미지".data(using: .utf8)!}
    return Just(imageDataList).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteImage(
    _ url: String,
    type: travelPlan.ImageStorageServiceType
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteImages(
    _ urls: [String],
    type: travelPlan.ImageStorageServiceType
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
