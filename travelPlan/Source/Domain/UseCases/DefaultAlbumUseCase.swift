//
//  DefaultAlbumUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Combine
import Photos

final class DefaultAlbumUseCase {
  // MARK: - Properties
  private let sortDescriptors = [
    NSSortDescriptor(key: "creationDate", ascending: false), // 가장 최근에 생성된 사진순
    NSSortDescriptor(key: "modificationDate", ascending: false) // 가장 최근에 수정된 사진순
  ]
  
  private var photoEntity = [PhotoEntity]()
  private var selectedIndexArray = [Int]()
}

// MARK: - AlbumUseCase
extension DefaultAlbumUseCase: AlbumUseCase {
  var maxSelectedImageCount: Int {
    return 20
  }
  
  func getAssets() -> [PHAsset] {
    let fetchOptions = PHFetchOptions().set {
      $0.predicate = NSPredicate(
        format: "mediaType == %d",
        PHAssetMediaType.image.rawValue
      )
      $0.sortDescriptors = self.sortDescriptors
      $0.includeAssetSourceTypes = .typeUserLibrary
    }
    let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
    let assets = convertAlbumToPHAssets(fetchResult: fetchResult)
    
    return assets
  }
}

// MARK: - Private Helpers
extension DefaultAlbumUseCase {
  private func convertAlbumToPHAssets(fetchResult: PHFetchResult<PHAsset>) -> [PHAsset] {
    var assets = [PHAsset]()
    fetchResult.enumerateObjects { asset, _, _ in
      assets.append(asset)
    }
    
    return assets
  }
}
