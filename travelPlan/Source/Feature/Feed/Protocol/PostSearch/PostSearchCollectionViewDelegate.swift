//
//  PostSearchCollectionViewDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/08.
//

import Foundation

protocol PostSearchCollectionViewDelegate: AnyObject {
  func didSelectTag(at indexPath: IndexPath)
}
