//
//  PostMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/20/24.
//

import Foundation
import UIKit

struct PostMapper {
  static func toPostInfo(_ post: Post, thumbnails: [Data]) -> PostInfo {
    let tripDate = post.detail.tripDate
    let postHeaderContentBottomInfo = PostHeaderContentBottomInfo(
      userName: post.author.nickname,
      duration: DateTimeConverter.periodYMD(from: tripDate.startDate, to: tripDate.endDate),
      yearMonthDayRange: DateTimeConverter.period(from: tripDate.startDate, to: tripDate.endDate))
    let postHeaderContentInfo = PostHeaderContentInfo(
      title: post.detail.title,
      bottomViewInfo: postHeaderContentBottomInfo)
    let postHeaderInfo = PostHeaderInfo(
      imageData: post.author.profileImageData,
      contentInfo: postHeaderContentInfo)
    let postContentInfo = PostContentInfo(
      text: post.detail.content.first?.text ?? "",
      thumbnailImageDataList: thumbnails)
    let postFooterInfo = PostFooterInfo(
      heartCount: String(post.detail.likes),
      heartState: post.liked ?? false,
      commentCount: String(post.detail.comments))
    return PostInfo(
      postId: post.detail.postID,
      header: postHeaderInfo,
      content: postContentInfo,
      footer: postFooterInfo)
  }
  
  static func toPostDetails(_ post: Post, category: Post.Category) -> PostDetails {
    var textIndex = 0
    var imageIndex = 0
    var content: [PostContentEntity] = (1...(post.detail.content.count + post.highResolveImages.count)).map { i in
      if post.detail.content.count > textIndex, post.detail.content[textIndex].sort == i {
        let entity = PostContentEntity.text(post.detail.content[textIndex].text)
        textIndex += 1
        return entity
      } else {
        let entity = PostContentEntity.image(post.highResolveImages[imageIndex].imageData ?? Data())
        imageIndex += 1
        return entity
      }
    }
    
    /// 비어있는 이미지 제거.
    content = content.filter { entity in
      if case .image(let data) = entity, data.count < 1 {
        return false
      }
      return true
    }
    
    let postDetail = Post.Detail<[PostContentEntity]>(
      postID: post.detail.postID, title: post.detail.title,
      content: content, likes: post.detail.likes,
      comments: post.detail.comments, location: post.detail.location,
      createAt: post.detail.createAt, tripDate: post.detail.tripDate)
    // 좋아요는 서버를 통해 확인받아야 합니다.
    return PostDetails(detail: postDetail, author: post.author, isFavorite: false, category: category)
  }
}
