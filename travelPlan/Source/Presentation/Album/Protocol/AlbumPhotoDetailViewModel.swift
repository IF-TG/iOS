//
//  AlbumPhotoDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/24/24.
//

import Foundation

typealias AlbumPhotoDetailViewModel = AlbumPhotoDetailViewModelable & AlbumPhotoDetailViewModelPageDelegate

protocol AlbumPhotoDetailViewModelable: ViewModelable
where Input == AlbumPhotoDetailViewModelInput,
      State == AlbumPhotoDetailViewModelState { }

protocol AlbumPhotoDetailViewModelPageDelegate: AnyObject {
  func pop()
}
