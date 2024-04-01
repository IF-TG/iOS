//
//  DefaultPhotoService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/6/24.
//

import Photos
import UIKit
import PhotosUI

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
      completion(image)
    }
  }
  
  func presentLimitedLibraryPicker(from controller: UIViewController) {
    if #available(iOS 14, *) {
      if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited {
        print(controller)
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller)
        print("추가 선택 alert 띄워짐")
      }
    } else {
      // Fallback on earlier versions
    }
  }
}
