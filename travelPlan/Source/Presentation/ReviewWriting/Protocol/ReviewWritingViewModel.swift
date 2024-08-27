//
//  ReviewWritingViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/23/24.
//

import Foundation
import Combine

typealias ReviewWritingViewModel = ReviewWritingViewModelable & ReviewWritingViewModelPageDelegate

protocol ReviewWritingViewModelable: ViewModelable
where Input == ReviewWritingViewModelInput,
      State == ReviewWritingViewModelState {}

// TODO: - DataSourceable

// TODO: - PageDelegate
protocol ReviewWritingViewModelPageDelegate {
  func didTapAlbumButton()
  func showCategoryBottomSheet()
  func pop()
  func pop(with post: Post?)
  func presentPlan()
}
