//
//  DefaultPhotoAuthorizationUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/30/24.
//

import Foundation
import Photos
import Combine

protocol PhotoAuthorizationUseCase {
  var authorizationStatus: PHAuthorizationStatus { get }
  
  func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never>
}

extension PhotoAuthorizationUseCase {
  var authorizationStatus: PHAuthorizationStatus {
    if #available(iOS 14, *) {
      return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    } else {
      return PHPhotoLibrary.authorizationStatus()
    }
  }
}
