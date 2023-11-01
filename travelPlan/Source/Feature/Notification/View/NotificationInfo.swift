//
//  NotificationInfo.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import Foundation

struct NotificationInfo {
  let userName: String
  let details: String?
  let duration: String
  let type: NotificationType
}

extension NotificationInfo {
  static func mockData() -> [Self] {
    return [
      .init(userName: "강강강이", details: "가하하\n와라랏\n와랏!!", duration: "2020.13.21", type: .comment(postTitle: "여행여행")),
      .init(userName: "laywenderlich", details: "글 내용 글 내용 글 내용 글 내용 글 내용 글 내용 글 내용", duration: "2일", type:  .commentReply(postTitle: "여행여행")),
      .init(userName: "하하하하하하", details: "글 내용 글 내용 글 내용 글 ", duration: "1일", type: .heart(postTitle: "하하핳하하핳")),
      .init(userName: "나나낭이", details: "나하하하\n나와라랏\n나와랏!!", duration: "2020.13.24", type: .commentReply(postTitle: "나 지금 여행여행")),
      .init(userName: "나laywenderlich", details: "나글 내용 나글 내용 나글 내용 나나 내용 글 내용", duration: "3일", type:  .comment(postTitle: "나 지금 여행여행")),
      .init(userName: "나하하하하하하", details: nil, duration: "1일", type: .heart(postTitle: "나하 하하하"))]
  }
}
