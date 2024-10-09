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
  private var fetchResult: PHFetchResult<PHAsset>?
}

// MARK: - AlbumUseCase
extension DefaultAlbumUseCase: AlbumUseCase {
  var maxSelectPhotoCount: Int {
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
    self.fetchResult = fetchResult
    return convertAlbumToPHAssets(fetchResult: fetchResult)
  }
  
  func getChangedAssets(changeInstance: PHChange) -> [PHAsset]? {
    guard let fetchResult = fetchResult,
          let changes = changeInstance.changeDetails(for: fetchResult) else {
      return nil
    }
    
    if changes.hasIncrementalChanges {
      return convertAlbumToPHAssets(fetchResult: fetchResult)
    } else {
      return getAssets()
    }
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
