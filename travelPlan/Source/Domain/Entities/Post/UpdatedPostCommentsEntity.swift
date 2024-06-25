//
//  UpdatedPostCommentsEntity.swift
//  travelPlan
//
//  Created by 양승현 on 6/21/24.
//

import Foundation

struct UpdatedPostCommentsEntity {
  let postId: PostIdentifier
  let postComments: Int32
  let hasEnteredByDeferredDeepLink: Bool
}
