//
//  StorageService.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation
import FirebaseStorage
import Combine

public struct StorageService {
  // MARK: - Helpers
  func uploadImage(_ imageData: Data, type: UploadType) async throws -> String {
    let fileName = NSUUID().uuidString
    let reference = Storage.storage().reference(withPath: "/\(type.path)/\(fileName)")
    _ = try await reference.putDataAsync(imageData)
    return (try await reference.downloadURL()).absoluteString
  }
  
  func fetchImage(_ url: String, type: UploadType) -> AnyPublisher<Data, Error> {
    return Future { promise in
      guard let url = URL(string: url) else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      do {
        try Storage.storage()
          .reference(for: url)
          .getData(maxSize: type.maxSize) { data, error in
            if let error {
              promise(.failure(error))
            } else if let data {
              promise(.success(data))
            }
          }
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
}

// MARK: - Nested
extension StorageService {
  @frozen enum UploadType {
    case profileImage
    case postImage
    
    var path: String {
      switch self {
      case .profileImage:
        "profile_images"
      case .postImage:
        "post_images"
      }
    }
    
    var maxSize: Int64 {
      switch self {
      case .profileImage:
        /// 프로필 최대 30MB 제한
        30*1024*1024
      case .postImage:
        /// 포스트 이미지 최대 30MB로 제한
        100*1024*1024
      }
    }
  }
}
