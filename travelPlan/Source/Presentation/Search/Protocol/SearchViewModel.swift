//
//  SearchViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/7/24.
//

import Foundation

typealias SearchViewModel = SearchViewModelable
& SearchViewModelDataSourceable
& SearchViewModelPageDelegate

protocol SearchViewModelable: ViewModelable
where Input == SearchViewModelInput,
      State == SearchViewModelState {}

protocol SearchViewModelPageDelegate: AnyObject {
  func showDestinationDetailPage(indexPath: IndexPath)
  func showMoreDetailPage(sectionIndex: Int)
}

protocol SearchViewModelDataSourceable {
  func getCellViewModels(in section: Int) -> SearchSectionType
  func fetchHeaderTitle(in section: Int) -> String
  func numberOfItemsInSection(in section: Int) -> Int
  func numberOfSections() -> Int
}
