//
//  FetchedPostDetailForUniversalLinkEntity.swift
//  travelPlan
//
//  Created by 양승현 on 6/18/24.
//

import Foundation

struct FetchedPostDetailForUniversalLinkEntity: Codable {
  let postId: PostIdentifier
  let postTitle: String
  let authorId: UserIdentifier
  let postAuthorNickname: String
}
