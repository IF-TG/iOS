//
//  FiresabseStorageService.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation
import FirebaseStorage
import Combine

final class FiresabseStorageService: ImageStorageServiceProtocol {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Helpers
  func uploadImage(_ imageData: Data, type: ImageStorageServiceType) -> AnyPublisher<String, Error> {
    let uploadType = UploadType(from: type)
    let fileName = NSUUID().uuidString
    let reference = Storage.storage().reference(withPath: "/\(uploadType.path)/\(fileName)")
    return Future { promise in
      reference.putData(imageData) { _, error in
        if let error {
          promise(.failure(error))
          return
        }
        reference.downloadURL { url, error in
          if let error {
            promise(.failure(error))
            return
          }
          if let url {
            promise(.success(url.absoluteString))
          } else {
            promise(.failure(NSError(domain: "UnknownError", code: 0)))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func uploadImages(_ imageDataList: [Data], type: ImageStorageServiceType) -> AnyPublisher<[String], Error> {
    var urls: [(idx: Int, url: String)] = []
    let group = DispatchGroup()
    
    return Future { [weak self] promise in
      for (i, imageData) in imageDataList.enumerated() {
        group.enter()
        let subscription = self?.uploadImage(imageData, type: type)
          .subscribe(on: DispatchQueue.global(qos: .userInteractive))
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
              group.leave()
            }
          } receiveValue: { url in
            urls.append((i, url))
            group.leave()
          }
        self?.subscriptions.insert(subscription)
      }
      group.notify(queue: .global(qos: .userInteractive)) {
        promise(.success(urls.sorted { $0.idx < $1.idx }.map { $0.url }))
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchImage(_ url: String, type: ImageStorageServiceType) -> AnyPublisher<Data, Error> {
    let uploadType = UploadType(from: type)
    return Future { promise in
      guard let url = URL(string: url) else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      do {
        try Storage.storage()
          .reference(for: url)
          .getData(maxSize: uploadType.maxSize) { data, error in
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
  
  func fetchImages(_ urls: [String], type: ImageStorageServiceType) -> AnyPublisher<[Data], any Error> {
    return Publishers
      .Sequence(sequence: urls)
      .flatMap { [weak self] url in
        return self?.fetchImage(url, type: type)
          .eraseToAnyPublisher() ?? Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher()
      }.collect()
      .eraseToAnyPublisher()
  }
  
  func deleteImage(_ url: String, type: ImageStorageServiceType) -> AnyPublisher<Void, any Error> {
    return Future<Void, Error> { promise in
      Storage.storage().reference(forURL: url)
        .delete { error in
          if let error {
            promise(.failure(error))
            return
          }
          promise(.success(()))
      }
    }.eraseToAnyPublisher()
  }
  
  func deleteImages(_ urls: [String], type: ImageStorageServiceType) -> AnyPublisher<Void, any Error> {
    return Publishers
      .Sequence(sequence: urls)
      .flatMap { [weak self] url in
        guard let self else {
          return Fail<Void, any Error>(error: ReferenceError.invalidReference).eraseToAnyPublisher()
        }
        return deleteImage(url, type: type)
      }.collect()
      .tryMap { _ in () }
      .eraseToAnyPublisher()
  }
}

// MARK: - Nested
extension FiresabseStorageService {
  @frozen enum UploadType {
    case profileImage
    case postImage
    
    init(from: ImageStorageServiceType) {
      switch from {
      case .postImage:
        self = .postImage
      case .profileImage:
        self = .profileImage
      }
    }
    
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
        /// 포스트 이미지 최대 100MB로 제한
        100*1024*1024
      }
    }
  }
}
