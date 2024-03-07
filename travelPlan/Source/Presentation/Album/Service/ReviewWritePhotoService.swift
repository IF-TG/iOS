//
//  ReviewWritePhotoService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/6/24.
//

import Photos
import UIKit

final class ReviewWritePhotoService: PhotoService {
  // MARK: - Properties
  private let imageManager = PHCachingImageManager()
  
  // MARK: - Helpers
  func convertAlbumToPHAssets(
    album: PHFetchResult<PHAsset>,
    completion: @escaping ([PHAsset]) -> Void
  ) {
    var assets = [PHAsset]()
    defer { completion(assets) }
    
    guard 0 < album.count else { return }
    album.enumerateObjects { asset, _, _ in
      assets.append(asset)
    }
  }
  
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
