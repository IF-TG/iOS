//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/7/24.
//

import Foundation

protocol SearchViewModel: ViewModelable,
                          SearchViewModelDataSourceable,
                          SearchViewModelPageDelegate
where Input == SearchViewModelInput,
      State == SearchViewModelState {}

protocol SearchViewModelPageDelegate {
  func pop()
  func showDetailPage(indexPath: IndexPath)
}

protocol SearchViewModelDataSourceable {
  func getCellViewModels(in section: Int) -> SearchItemType
  func fetchHeaderTitle(in section: Int) -> String
  func numberOfItemsInSection(in section: Int) -> Int
  func numberOfSections() -> Int
}
