//
//  PostOrderCategoryBottomSheet.swift
//  travelPlan
//
//  Created by 양승현 on 3/22/24.
//

import UIKit

protocol PostOrderCategoryBottomSheetDelegate: BasePostCategoryBottomSheetDelegate
where Category == TravelOrderType {}

final class PostOrderCategoryBottomSheet: BasePostCategoryBottomSheet {
  // MARK: - Properties
  weak var delegate: (any PostOrderCategoryBottomSheetDelegate)?
  
  // MARK: - Lifecycle
  init() {
    super.init(bottomSheetMode: .couldBeFull, titles: TravelOrderType.toKoreanList)
  }
  
  required init?(coder: NSCoder) { nil }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    guard
      let selectedTitle,
      let selectedOrderType = TravelOrderType(rawValue: selectedTitle)
    else { return }
    delegate?.notifySelectedCategory(selectedOrderType)
  }
}
