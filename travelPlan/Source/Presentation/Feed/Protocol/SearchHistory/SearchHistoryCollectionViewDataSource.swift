//
//  SearchHistoryCollectionViewDataSource.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/08.
//

import Foundation

protocol SearchHistoryCollectionViewDataSource: AnyObject {
  func getTextString(at indexPath: IndexPath) -> String
  func numberOfSections() -> Int
  func cellForItems(at section: Int) -> SearchHistorySectionModel.Item
  func numberOfItems(in section: Int) -> Int
  func fetchHeaderTitle(in section: Int) -> SearchHistorySectionModel.Section
}
