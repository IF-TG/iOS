//
//  BasePostViewDelegatable.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import UIKit

protocol BasePostViewDelegatable: AnyObject {
  var postViewDelegate: BasePostViewDelegate? { get }
}

typealias BasePostCell = UICollectionViewCell & BasePostViewDelegatable
