//
//  PostSearchCollectionViewDataSource.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/08.
//

import Foundation

protocol PostSearchCollectionViewDataSource: AnyObject {
  func getTextString(at indexPath: IndexPath) -> String
  func numberOfSections() -> Int
  func cellForItems(at section: Int) -> PostSearchSectionModel.Item
  func numberOfItems(in section: Int) -> Int
  func fetchHeaderTitle(in section: Int) -> PostSearchSectionModel.Section
}
