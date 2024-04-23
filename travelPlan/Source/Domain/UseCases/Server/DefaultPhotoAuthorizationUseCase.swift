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
    return Future { promise in
      if #available(iOS 14, *) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
          promise(.success(status))
        }
      } else {
        PHPhotoLibrary.requestAuthorization { status in
          promise(.success(status))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
