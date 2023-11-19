//
//  PostDetailTableViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

protocol PostDetailTableViewAdapterDelegate: AnyObject {
  func disappearTitle(_ title: String)
  func willDisplayTitle()
  
  func showUploadedUserProfilePage(with userId: Int)
  func showCategoryDetailPage()
}
