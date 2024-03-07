//
//  AlbumInfo.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import Photos

struct AlbumInfo: Identifiable {
  let id: String?
  let name: String
  let album: PHFetchResult<PHAsset>
  
  init(fetchResult: PHFetchResult<PHAsset>, albumName: String) {
    id = nil
    name = albumName
    album = fetchResult
  }
}
