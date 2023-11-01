//
//  NotificationType.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import Foundation

enum NotificationType {
  case comment(postTitle: String)
  case commentReply(postTitle: String)
  case heart(postTitle: String)
  
  var path: String {
    switch self {
    case .comment:
      return "message-dots-circle"
    case .commentReply:
      return "corner-down-right"
    case .heart:
      return "unselectedHeart"
    }
  }
  
  var postTitle: String {
    switch self {
    case .comment(postTitle: let title):
      return title
    case .commentReply(postTitle: let title):
      return title
    case .heart(postTitle: let title):
      return title
    }
  }
  
  var suffixWords: String {
    switch self {
    case .comment(postTitle: let title):
      return "님이 " + title + " 글에 댓글을 남겼어요."
    case .commentReply(postTitle: let title):
      return "님이 " + title + " 글에 답글을 남겼어요."
    case .heart(postTitle: let title):
      return "님이 " + title + " 글에 좋아요를 남겼어요."
    }
  }
}
