//
//  AlbumUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 3/19/24.
//

import Foundation
import Photos
//import Combine

protocol AlbumUseCase {
  func getPhotos(mediaType: MediaType) -> [PHAsset]
}
