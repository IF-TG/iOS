//
//  DefaultPhotoService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/6/24.
//

import Photos
import UIKit

final class DefaultPhotoService {
  // MARK: - Properties
  private let imageManager = PHCachingImageManager()
}

// MARK: - PhotoService
extension DefaultPhotoService: PhotoService {
  func fetchImage(
    asset: PHAsset,
    size: CGSize,
    contentMode: PHImageContentMode,
    completion: @escaping (UIImage) -> Void
  ) {
    let options = PHImageRequestOptions().set {
      $0.deliveryMode = .highQualityFormat
    }
    
    imageManager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: contentMode,
      options: options) { image, _ in
        guard let image else { return }
        
        completion(image)
      }
  }
}
