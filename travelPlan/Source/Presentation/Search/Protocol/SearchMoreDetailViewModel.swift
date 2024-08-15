//
//  SearchMoreDetailViewModel.swift
//  travelPlan
//
//  Created by SeokHyun on 8/7/24.
//

import Foundation

typealias SearchMoreDetailViewModel = SearchMoreDetailViewModelable
& SearchMoreDetailViewModelDataSourceable
& SearchMoreDetailViewModelPageDelegate

protocol SearchMoreDetailViewModelable: ViewModelable
where Input == SearchMoreDetailViewModelInput,
      State == SearchMoreDetailViewModelState {}

protocol SearchMoreDetailViewModelPageDelegate: AnyObject {
  func showDestinationDetail(indexPath: IndexPath)
  func pop()
}

protocol SearchMoreDetailViewModelDataSourceable {  
  func headerInfo() -> SearchDetailHeaderInfo
  func numberOfItemsInSection() -> Int
  func destinationInfo(indexPath: IndexPath) -> TravelDestinationInfo
}
