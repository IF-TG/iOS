//
//  PostMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/20/24.
//

import Foundation

struct PostMapper {
  static func toPostInfo(_ post: Post, thumbnails: [String]) -> PostInfo {
    // TODO: - 서버에서 tripDate어떻게주는지 알아야함
    // 22.11.22 , 22.11.13 이런식으로 오는데.. 그럼 몇일인지 구하는 것도 구현해야함
    let postHeaderContentBottomInfo = PostHeaderContentBottomInfo(
      userName: post.author.nickname,
      duration: "\(post.detail.tripDate.start) ~ \(post.detail.tripDate.end)",
      yearMonthDayRange: "3일")
    let postHeaderContentInfo = PostHeaderContentInfo(
      title: post.detail.title,
      bottomViewInfo: postHeaderContentBottomInfo)
    let postHeaderInfo = PostHeaderInfo(
      imageURL: post.author.profileUri,
      contentInfo: postHeaderContentInfo)
    let postContentInfo = PostContentInfo(
      text: post.detail.content,
      thumbnailURLs: thumbnails)
    let postFooterInfo = PostFooterInfo(
      heartCount: String(post.detail.likes),
      heartState: post.liked,
      commentCount: String(post.detail.comments))
    return PostInfo(
      postId: Int(post.detail.postID),
      header: postHeaderInfo,
      content: postContentInfo,
      footer: postFooterInfo)
  }
}
