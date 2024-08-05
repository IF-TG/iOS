//
//  SearchResultListViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/2/24.
//

import Foundation

protocol SearchResultListViewModelPageDelegate: AnyObject {
  func pop()
  func showDestinationDetailPage(id: Int, contentTypeId: Int)
}

protocol SearchResultListViewModel: ViewModelable, SearchResultDataSourceable, SearchResultListViewModelPageDelegate
where Input == SearchResultListViewModelInput,
      State == SearchResultListViewModelState { }
