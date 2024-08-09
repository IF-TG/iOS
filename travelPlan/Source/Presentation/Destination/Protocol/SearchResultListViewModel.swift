//
//  SearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/2/24.
//

import Foundation

protocol SearchResultListViewModel: ViewModelable, SearchResultDataSourceable, SearchResultListViewModelPageDelegate
where Input == SearchResultListViewModelInput,
      State == SearchResultListViewModelState { }

protocol SearchResultListViewModelPageDelegate: AnyObject {
  func pop()
  func showDestinationDetailPage(id: Int, contentTypeId: Int)
}

protocol SearchResultDataSourceable {
  /// index 0: category
  /// index 1: destination
  var dataSource: [SearchResultSectionModel] { get }
}
