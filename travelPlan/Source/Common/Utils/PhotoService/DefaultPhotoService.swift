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
  private let imageManager = PHCachingImageManager.default()
}

// MARK: - PhotoService
extension DefaultPhotoService: PhotoService {
  func fetchImage(
    asset: PHAsset,
    size: CGSize,
    contentMode: PHImageContentMode,
    resizeModeOption: PHImageRequestOptionsResizeMode,
    completion: @escaping (UIImage) -> Void
  ) {
    let options = PHImageRequestOptions().set {
      $0.deliveryMode = .highQualityFormat
      $0.resizeMode = resizeModeOption
    }
    
    imageManager.requestImage(
      for: asset,
      targetSize: size,
      contentMode: contentMode,
      options: options
    ) { image, _ in
      guard let image else { return }
      
      DispatchQueue.main.async {
        completion(image)
      }
    }
  }
}
