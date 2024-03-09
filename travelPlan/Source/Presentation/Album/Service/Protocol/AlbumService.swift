//
//  AlbumService.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import Photos
import UIKit

protocol AlbumService {
  func getAlbums(mediaType: MediaType, completion: @escaping ([AlbumInfo]) -> Void)
}
