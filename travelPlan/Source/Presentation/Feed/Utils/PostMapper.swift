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
  
  static func toPostDetails(_ post: Post, category: PostCategory) -> PostDetails {
    // TODO: - post upload에서 컨텐츠, 이미지 순서를 어떻게 나타내느냐 고려한 후에 content를 그에맞게 반영해야합니다.
    var content: [PostDetailContentType] = [.text(post.detail.content)]
    content += post.highResolveImages.map { postImage -> PostDetailContentType in
        .image(postImage.imageUri)
    }
    
    let postDetail = Post.Detail<[PostDetailContentType]>(
      postID: post.detail.postID, title: post.detail.title,
      content: content, likes: post.detail.likes,
      comments: post.detail.comments, location: post.detail.location,
      createAt: post.detail.createAt, tripDate: post.detail.tripDate)
    // 좋아요는 서버를 통해 확인받아야 합니다.
    return PostDetails(detail: postDetail, author: post.author, isFavorite: false, category: category)
  }
}
