//
//  AtomicPost.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Foundation

public struct AtomicPost {
  // MARK: - Firestore를 활용하게 될 경우 authorId는 String이 되야 합니다.
  let authorId: UserIdentifier
  let detail: Post.Detail<[Post.PostContent]>
  let category: Post.Category
  let highResolveImages: [Post.PostImage]
}
