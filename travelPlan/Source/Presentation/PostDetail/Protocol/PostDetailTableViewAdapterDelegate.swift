//
//  PostDetailTableViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

protocol PostDetailTableViewAdapterDelegate: AnyObject {
  func disappearTitle()
  func willDisplayTitle()
  
  // TODO: - 프로필 페이지는 화면이 없기 때문에 일단 미반영!
  func showUploadedUserProfilePage(with userId: Int32)
  func showCategoryDetailPage()
}
