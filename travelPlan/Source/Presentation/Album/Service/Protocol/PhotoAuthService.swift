//
//  PhotoAuthService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import Photos
import UIKit

protocol PhotoAuthService {
  var authorizationStatus: PHAuthorizationStatus { get }
  var isLimited: Bool { get }
  
  func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void)
}
