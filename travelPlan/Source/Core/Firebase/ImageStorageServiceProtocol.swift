//
//  ImageStorageServiceProtocol.swift
//  travelPlan
//
//  Created by 양승현 on 4/26/24.
//

import Foundation
import Combine
@frozen enum ImageStorageServiceType {
  case profileImage
  case postImage
}

protocol ImageStorageServiceProtocol {
  func uploadImage(
    _ imageData: Data,
    type: ImageStorageServiceType
  ) -> AnyPublisher<String, Error>
  
  func uploadImages(
    _ imageDataList: [Data], 
    type: ImageStorageServiceType
  ) -> AnyPublisher<[String],Error>
  
  func fetchImage(_ url: String, type: ImageStorageServiceType) -> AnyPublisher<Data, Error>
  
  func fetchImages(_ urls: [String], type: ImageStorageServiceType) -> AnyPublisher<[Data], Error>
  
  func deleteImage(_ url: String, type: ImageStorageServiceType) -> AnyPublisher<Void, Error>
  
  func deleteImages(_ urls: [String], type: ImageStorageServiceType) -> AnyPublisher<Void, Error>
}
