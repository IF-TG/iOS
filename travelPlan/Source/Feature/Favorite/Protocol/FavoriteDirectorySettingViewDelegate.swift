//
//  FavoriteDirectorySettingViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import UIKit

protocol FavoriteDirectorySettingViewDelegate: AnyObject, BottomSheetViewDelegate {
  func favoriteDirectorySettingView(
    _ settingView: FavoriteDirectorySettingView,
    didTapOkButton: UIButton)
}

extension FavoriteDirectorySettingViewDelegate{
  func bottomSheetView(
    _ bottomSheetView: BottomSheetView,
    withPenGesture gesture: UIPanGestureRecognizer
  ) { }
}
