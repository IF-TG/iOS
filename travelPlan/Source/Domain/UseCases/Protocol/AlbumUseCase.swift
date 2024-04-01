//
//  AlbumUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Photos

protocol AlbumUseCase {
  var maxSelectedImageCount: Int { get }
  
  func getAssets() -> [PHAsset]
  func getChangedAssets(changeInstance: PHChange) -> [PHAsset]
}
