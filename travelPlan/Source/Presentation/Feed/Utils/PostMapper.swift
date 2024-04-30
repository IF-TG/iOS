//
//  PostMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/20/24.
//

import Foundation
import UIKit

struct PostMapper {
  // TODO: - 이미지, 섬네일등 Data로 오는것으로 변환해야합니다.
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
      imageData: post.author.profileImageData,
      contentInfo: postHeaderContentInfo)
    let postContentInfo = PostContentInfo(
      text: post.detail.content,
      thumbnailURLs: thumbnails)
    let postFooterInfo = PostFooterInfo(
      heartCount: String(post.detail.likes),
      heartState: post.liked,
      commentCount: String(post.detail.comments))
    return PostInfo(
      postId: post.detail.postID,
      header: postHeaderInfo,
      content: postContentInfo,
      footer: postFooterInfo)
  }
  
  static func toPostDetails(_ post: Post, category: Post.Category) -> PostDetails {
    var content: [PostContentEntity] = [.text(post.detail.content)]
    
    // TODO: - 지금은 content text이후에 단순히 이미지만 반환했지만, 추후에 text sort, image sort타입에 맞게 반환 해야합니다.
    let images: [PostContentEntity] = post.highResolveImages.compactMap { postImage -> PostContentEntity? in
      if let data = postImage.imageData {
        return .image(data)
      }
      return nil
    }
    content += images
    
    let postDetail = Post.Detail<[PostContentEntity]>(
      postID: post.detail.postID, title: post.detail.title,
      content: content, likes: post.detail.likes,
      comments: post.detail.comments, location: post.detail.location,
      createAt: post.detail.createAt, tripDate: post.detail.tripDate)
    // 좋아요는 서버를 통해 확인받아야 합니다.
    return PostDetails(detail: postDetail, author: post.author, isFavorite: false, category: category)
  }
}
