//
//  PhotoService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit
import Photos

protocol PhotoService {
  /// PHAsset을 image로 변환하는 메소드입니다.
  func fetchImage(asset: PHAsset,
                  size: CGSize,
                  contentMode: PHImageContentMode,
                  resizeModeOption: PHImageRequestOptionsResizeMode,
                  completion: @escaping (UIImage) -> Void)
}
