//
//  PHAsset+.swift
//  travelPlan
//
//  Created by SeokHyun on 3/24/24.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
  func convertToImage(
    for asset: PHAsset,
    targetSize: CGSize,
    contentMode: PHImageContentMode,
    options: PHImageRequestOptions?,
    completion: @escaping((UIImage?) -> Void)
  ) {
    let cachingManager = PHCachingImageManager.default()
    cachingManager.requestImage(
      for: asset,
      targetSize: targetSize,
      contentMode: contentMode,
      options: options) { image, _ in
        completion(image)
      }
  }
}
