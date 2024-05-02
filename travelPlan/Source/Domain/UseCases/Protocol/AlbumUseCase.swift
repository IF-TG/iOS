//
//  AlbumUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Photos

protocol AlbumUseCase {
  func getAssets() -> [PHAsset]
  func getChangedAssets(changeInstance: PHChange) -> [PHAsset]?
}
