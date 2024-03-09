//
//  ReviewWriteAlbumService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import Foundation
import Photos

final class ReviewWriteAlbumService: AlbumService {
  
  // MARK: - Properties
  private let sortDescriptors = [
    NSSortDescriptor(key: "creationDate", ascending: false),
    NSSortDescriptor(key: "modificationDate", ascending: false)
  ]
  
  // MARK: - Helpers
  func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void) {
    // 앨범 선언
    var albums = [AlbumInfo]()
    defer { completion(albums) }
    
    // 쿼리 설정
    let fetchOptions = PHFetchOptions().set {
      $0.predicate = getPredicate(mediaType: mediaType)
      $0.sortDescriptors = self.sortDescriptors
    }
    
    // standard 앨범을 query로 이미지 가져오기
    let standardFetchResult = PHAsset.fetchAssets(with: fetchOptions)
    albums.append(.init(fetchResult: standardFetchResult, albumName: mediaType.title))
    
    // smart 앨범을 query로 이미지 가져오기
    let smartAlbums = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum,
      subtype: .any,
      options: PHFetchOptions()
    )
    smartAlbums.enumerateObjects { [weak self] assetCollection, index, pointer in
      guard let self, index <= smartAlbums.count - 1 else {
        pointer.pointee = true
        return
      }
      
      // 스마트 앨범인 경우 (Asset count가 -1인 경우)
      if assetCollection.estimatedAssetCount == NSNotFound {
        let fetchOptions = PHFetchOptions().set {
          $0.predicate = self.getPredicate(mediaType: mediaType)
          $0.sortDescriptors = self.sortDescriptors
        }
        let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
        albums.append(.init(fetchResult: fetchResult, albumName: mediaType.title))
      }
    }
  }
}

// MARK: - Private Helpers
extension ReviewWriteAlbumService {
  private func getPredicate(mediaType: MediaType) -> NSPredicate {
    let format = "mediaType == %d"
    switch mediaType {
    case .all:
      return .init(
        format: format + " || " + format,
        PHAssetMediaType.image.rawValue,
        PHAssetMediaType.video.rawValue
      )
    case .image:
      return .init(
        format: format,
        PHAssetMediaType.image.rawValue
      )
    case .video:
      return .init(
        format: format,
        PHAssetMediaType.video.rawValue
      )
    }
  }
}
