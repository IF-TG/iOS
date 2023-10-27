//
//  PostViewBottomSheetAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/10.
//

import Foundation

protocol PostViewBottomSheetAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  // testtest아직안구현FIXME: - 아직안구현
  func PostViewBottomSheetCellItem(
    at index: Int,
    detailCategoryCase: PostSearchFilterType
  ) -> String
  
}

protocol PostVIewBottomSheetAdapterDelegate: AnyObject {
  func tappedCell(with data: String)
}

final class PostViewBottomSheetAdapter: NSObject {
  
}
