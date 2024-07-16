//
//  SearchHistoryCollectionViewDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/08.
//

import Foundation

protocol SearchHistoryCollectionViewDelegate: AnyObject {
  func didSelectTag(at indexPath: IndexPath)
}
