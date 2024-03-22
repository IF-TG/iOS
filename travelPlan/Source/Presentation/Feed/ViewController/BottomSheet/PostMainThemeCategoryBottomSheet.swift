//
//  PostMainThemeCategoryBottomSheet.swift
//  travelPlan
//
//  Created by 양승현 on 3/22/24.
//

import Foundation

protocol PostMainThemeCategoryBottomSheetDelegate: AnyObject {
  func notifySelectedMainTheme(_ category: TravelMainThemeType?)
}

final class PostMainThemeCategoryBottomSheet: BasePostCategoryBottomSheet {
  // MARK: - Properties
  private let mainTheme: TravelMainThemeType
  
  weak var delegate: (any PostMainThemeCategoryBottomSheetDelegate)?
  
  // MARK: - Lifecycle
  init(mainTheme: TravelMainThemeType) {
    self.mainTheme = mainTheme
    var bottomSheetMode: BaseBottomSheetViewController.ContentMode
    if mainTheme.rawValue == TravelMainThemeType.region(.busan).rawValue {
      bottomSheetMode = .full
    } else {
      bottomSheetMode = .couldBeFull
    }
    
    super.init(bottomSheetMode: bottomSheetMode, titles: mainTheme.titles)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    guard let selectedTitle else {
      delegate?.notifySelectedMainTheme(nil)
      return
    }
    var selectedMainTheme: TravelMainThemeType?
    switch mainTheme {
    case .season(_):
      guard let season = Season(rawValue: selectedTitle) else { return }
        selectedMainTheme = .season(season)
    case .region(_):
      guard let region = TravelRegion(rawValue: selectedTitle) else { return }
      selectedMainTheme = .region(region)
    case .travelTheme(_):
      guard let theme = TravelTheme(rawValue: selectedTitle) else { return }
      selectedMainTheme = .travelTheme(theme)
    case .partner(_):
      guard let partner = TravelPartner(rawValue: selectedTitle) else { return }
      selectedMainTheme = .partner(partner)
    default:
      break
    }
    delegate?.notifySelectedMainTheme(selectedMainTheme)
  }
}
