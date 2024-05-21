//
//  PostDetailChatViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 5/21/24.
//

import Combine
import Foundation

final class PostDetailChatViewModel {
  // MARK: - Nested
  @frozen fileprivate enum CommentUseCaseInput {
    case send(PostDetailChatViewModelable.UserInputText)
    case edit(PostDetailChatViewModelable.UserInputText)
    case delete(PostDetailChatViewModelable.Section)
  }
  
  @frozen fileprivate enum NestedCommentUseCaseInput {
    case send(PostDetailChatViewModelable.UserInputText)
    case edit(PostDetailChatViewModelable.UserInputText)
    case delete(IndexPath)
  }

  // MARK: - Dependencies
  private let postCommentsAndPostLikeStateFetchUseCase: PostCommentsAndPostLikeStateFetchUseCase
  
  private let postCommentUseCase: PostCommentUseCase
  
  private let postNestedCommentUseCase: PostNestedCommentUseCase
  
  // MARK: - Properties
  private var comments: [PostCommentEntity] = []

  private let actions: PostDetailChatViewModelActions

  // MARK: - Lifecycle
  init(
    postCommentsAndPostLikeStateFetchUseCase: PostCommentsAndPostLikeStateFetchUseCase,
    postCommentUseCase: PostCommentUseCase,
    postNestedCommentUseCase: PostNestedCommentUseCase,
    actions: PostDetailChatViewModelActions
  ) {
    self.postCommentsAndPostLikeStateFetchUseCase = postCommentsAndPostLikeStateFetchUseCase
    self.postCommentUseCase = postCommentUseCase
    self.postNestedCommentUseCase = postNestedCommentUseCase
    self.actions = actions
  }
}

// MARK: - PostDetailChatDataSource
extension PostDetailChatViewModel: PostDetailChatDataSource {
  var numberOfSections: NumberOfComments {
    comments.count
  }
  
  func numberOfRows(in section: PostDetailSection) -> Int {
    comments[section.commentIndex].nestedComments.count
  }
  
  func commentItem(in section: PostDetailSection) -> PostCommentInfo {
    let postComment = comments[section.commentIndex]
    let baseInfo: BasePostDetailCommentInfo = .init(
      commentId: postComment.commentId,
      userName: postComment.userName,
      userProfileImageData: postComment.userProfileImageData,
      timestamp: postComment.timestamp,
      comment: postComment.isDeleted ? "댓글이 삭제되었습니다." : postComment.comment,
      isOnHeart: postComment.isOnHeart,
      heartCountText: "\(postComment.hearts)")
    return .init(baseInfo: baseInfo, isDeleted: postComment.isDeleted)
  }
  
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo {
    let commentIndex = SectionType.commentIndex(section: indexPath.section)
    let postComment = comments[commentIndex]
    let postReply = postComment.nestedComments[indexPath.row]
    
    let commentInfo = BasePostDetailCommentInfo(
      commentId: postReply.nestedCommentId,
      userName: postReply.nickname,
      userProfileImageData: postReply.userProfileImageData,
      timestamp: postReply.timestamp,
      comment: postReply.comment,
      isOnHeart: postReply.isOnHeart,
      heartCountText: "\(postReply.hearts)")
    return .init(
      isFirstReply: indexPath.row == 0,
      commentInfo: commentInfo)
  }
}
