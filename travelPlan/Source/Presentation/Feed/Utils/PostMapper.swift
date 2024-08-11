//
//  PostMapper.swift
//  travelPlan
//
//  Created by 양승현 on 3/20/24.
//

import Foundation
import UIKit

public struct PostMapper {
  public static func toPostInfo(_ post: Post, thumbnails: [Data]) -> PostInfo {
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
      heartCount: post.detail.likes,
      heartState: post.liked ?? false,
      commentCount: post.detail.comments)
    return PostInfo(
      postId: post.detail.postID,
      header: postHeaderInfo,
      content: postContentInfo,
      footer: postFooterInfo)
  }
  
  public static func toPostDetails(_ post: Post, category: Post.Category) -> PostDetails {
    let content: [PostContentEntity] = (post.detail.content.map(convert(postContent:)) +
     post.highResolveImages.compactMap(convert(postImage:))
    )
    .sorted(by: comparer)
    .map { $0.postContentEntity }
    
    let postDetail = Post.Detail<[PostContentEntity]>(
      postID: post.detail.postID, title: post.detail.title,
      content: content, likes: post.detail.likes,
      comments: post.detail.comments, location: post.detail.location,
      createAt: post.detail.createAt, tripDate: post.detail.tripDate)
    
    // MARK: Firestore를 사용한 경우 좋아요는 서버를 통해 확인받아야 합니다.
    return PostDetails(
      detail: postDetail,
      author: post.author,
      isFavorite: false,
      hasHeart: post.liked ?? false,
      category: category)
  }
}

// MARK: - Helpers
internal extension PostMapper {
  typealias SortAndPostContent = (sort: Int, postContentEntity: PostContentEntity)
  static func convert(postContent: Post.PostContent) -> SortAndPostContent {
    (postContent.sort, PostContentEntity.text(postContent.text))
  }
  
  static func convert(postImage: Post.PostImage) -> SortAndPostContent? {
    guard let imageData = postImage.imageData else { return nil }
    return (Int(postImage.sort), PostContentEntity.image(imageData))
  }
  
  static var comparer = { (lhs: PostMapper.SortAndPostContent, rhs: PostMapper.SortAndPostContent) -> Bool in
    lhs.sort < rhs.sort
  }
}
