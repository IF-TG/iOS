//
//  PostDetailTableViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

protocol PostDetailTableViewDelegate: AnyObject {
  func disappearTitle(_ title: String)
  func willDisplayTitle()
}
