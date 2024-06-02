//
//  PostViewDelegatable.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import UIKit

protocol PostViewDelegatable: AnyObject {
  var postViewDelegate: PostViewDelegate? { get set }
}

typealias BasePostCell = UICollectionViewCell & PostViewDelegatable
