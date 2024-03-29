//
//  DefaultPhotoAuthorizationUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/27/24.
//

import Foundation
import Combine
import Photos

final class DefaultPhotoAuthorizationUseCase: PhotoAuthorizationUseCase {
  func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never> {
    if #available(iOS 14, *) {
      return Future { promise in
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
          promise(.success(status))
        }
      }
      .eraseToAnyPublisher()
    } else {
      return Future { promise in
        PHPhotoLibrary.requestAuthorization { status in
          promise(.success(status))
        }
      }.eraseToAnyPublisher()
    }
  }
}
