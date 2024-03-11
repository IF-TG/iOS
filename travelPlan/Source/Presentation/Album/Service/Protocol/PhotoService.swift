//
//  PhotoService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit
import Photos

protocol PhotoService {
  func convertAlbumToPHAssets(album: PHFetchResult<PHAsset>, 
                              completion: @escaping ([PHAsset]) -> Void)
  func fetchImage(asset: PHAsset,
                  size: CGSize,
                  contentMode: PHImageContentMode,
                  completion: @escaping (UIImage) -> Void)
}
