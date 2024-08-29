//
//  AlbumViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/24/24.
//

import Foundation

typealias AlbumViewModel = AlbumViewModelable  & AlbumViewModelPageDelegate & AlbumViewModelDataSourceable

protocol AlbumViewModelable: ViewModelable
where AlbumViewModelInput == Input,
      AlbumViewModelState == State {}

protocol AlbumViewModelPageDelegate {
  func showDetailPhoto(at itemIndex: Int)
  func pop()
  func callSetting()
  func popByPassingAssets()
  func presentLimitedLibraryPicker()
}

protocol AlbumViewModelDataSourceable {
  func numberOfItemsInSection() -> Int
  func photoModel(ItemIndex: Int) -> PhotoModel
}
