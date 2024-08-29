//
//  PhotoAuthorizationRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 3/30/24.
//

import Foundation
import Photos
import Combine

protocol PhotoAuthorizationRepository {
  var authorizationStatus: PHAuthorizationStatus { get }
  
  func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never>
}

extension PhotoAuthorizationRepository {
  var authorizationStatus: PHAuthorizationStatus {
    if #available(iOS 14, *) {
      return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    } else {
      return PHPhotoLibrary.authorizationStatus()
    }
  }
}
