//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation

/// 임시
struct PostDetails {
  let postId: Int
  let userName: String
  let userId: Int
  var isFavoritePost: Bool
  let userThumbnailPath: String
  let travelDuration: String
  let travelCalenderDateRange: String
  let uploadedDescription: String
  let title: String
  // 임시..
  let postContents: [PostDetailContentInfo]
  let category: String
}

enum PostDetailSectionType: Int {
  case postDescription
  case postContent
  /// 2 이상부터는 comments가 있습니다.
  case comments
  
  init?(rawValue: Int) {
    switch rawValue {
    case 0:
      self = .postDescription
    case 1:
      self = .postContent
    default:
      self = .comments
    }
  }
}

struct PostComment {
  let id: Int64
  let userProfileURL: String
  let userName: String
  let timestamp: String
  let comment: String
  let isOnHeart: Bool
  let heartCountText: String
  let replies: [PostReply]
}

struct PostReply {
  let id: Int64
  let userProfileURL: String
  let userName: String
  let timestamp: String
  let comment: String
  let heartCountText: String
  let isOnHeart: Bool
  let isFirstReply: Bool
}

final class PostDetailViewModel {
  private let DefaultSectionCount = 2
  
  private var postDetails: PostDetails?
  
  private var comments: [PostComment] = []
  
  init() {
    postDetails = fetchMockAllData()
    comments = fetchMockAllComments()
  }
}

// MARK: - PostDetailTableViewDataSource
extension PostDetailViewModel: PostDetailTableViewDataSource {
  func commentItem(in section: Int) -> BasePostDetailCommentInfo {
    let postComment = comments[section - DefaultSectionCount]
    return .init(
      commentId: postComment.id,
      userName: postComment.userName,
      userProfileURL: postComment.userProfileURL,
      timestamp: postComment.timestamp,
      comment: postComment.comment,
      isOnHeart: postComment.isOnHeart,
      heartCountText: postComment.heartCountText)
  }
  
  var title: String {
    guard let postDetails else { return "" }
    return postDetails.title
  }
  
  var cateogry: String {
    guard let postDetails else { return "" }
    return postDetails.category
  }
  
  var profileAreaItem: PostDetailProfileAreaInfo {
    return .init(
      userName: postDetails?.userName ?? "이름없는 사용자",
      userId: postDetails?.userId ?? 0,
      userThumbnailPath: postDetails?.userThumbnailPath ?? "미정",
      travelDuration: postDetails?.travelDuration ?? "미정",
      travelCalendarDateRange: postDetails?.travelCalenderDateRange ?? "미정",
      uploadedDescription: postDetails?.uploadedDescription ?? "미정")
  }
  
  func postContentItem(at row: Int) -> PostDetailContentInfo {
    guard let postDetails else { return .text("") }
    return postDetails.postContents[row]
  }
  
  var numberOfSections: Int {
    if postDetails == nil { return 0 }
    return DefaultSectionCount + comments.count
  }
  
  func numberOfItems(in section: Int) -> Int {
    guard let postDetails else {
      print("DEBUG: 서버에서 postDetails 데이터를 가져오지 못했습니다.")
      return 0
    }
    let sectionType: PostDetailSectionType = .init(rawValue: section) ?? .postContent
    switch sectionType {
    case .postDescription:
      return 1
    case .postContent:
      return postDetails.postContents.count
    default:
      return comments[section-DefaultSectionCount].replies.count
    }
  }
}

private extension PostDetailViewModel {
  func fetchMockAllData() -> PostDetails {    
    let texts: [String] = [
      """
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      \n
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1 내용1
      """,
      """
      내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2
      내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2
      내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2 내용2
      """,
      """
      내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3
      내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3
      내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3 내용3
      """,
      """
      내용4\n\n\n내용4내용4내용4내용4\n\n내용4내용4내용4내용4내용4
      """]
    let contents: [PostDetailContentInfo] = [
      .text(texts[0]), .image("tempThumbnail6"),
      .text(texts[1]), .image("tempThumbnail7"),
      .text(texts[2]), .image("tempThumbnail8"), .text(texts[3])]
    
    return .init(
      postId: 0, userName: "닉네임은 여덟자리", userId: 0,
      isFavoritePost: false, userThumbnailPath: "tempProfile1",
      travelDuration: "1박 2일", travelCalenderDateRange: "23.12.31 ~ 23.12.31",
      uploadedDescription: "2023. 12. 31 12:12", title: "곧 크리스마스가 다가옵니다. 하하하. 미리메리크리스마스~",
      postContents: contents, category: "여행테마 > 휴식, 동반자 > 가족 ...")
  }
  
  func fetchMockAllComments() -> [PostComment] {
    let repliesAboutFirstComment: [PostReply] = [
      .init(id: 0, userProfileURL: "tempProfile2", userName: "나야나 스택뷰 설명!",
            timestamp: "2일전", comment:
              """
              Stack views let you leverage the power of Auto Layout,
              creating user interfaces that can dynamically adapt to the device’s orientation,
              screen size, and any changes in the available space.
              
              The stack view manages the layout of all the views in its arrangedSubviews property.
              These views are arranged along the stack view’s axis, based on their order in the arrangedSubviews array.
              
              
              The exact layout varies depending on the stack view’s axis, distribution, alignment, spacing, and other properties.
              """
            , heartCountText: "", isOnHeart: false, isFirstReply: true),
      .init(id: 1, userProfileURL: "tempProfile3", userName: "흰눈 펑펑", timestamp: "2일전", comment: "오 그럽시다. 크리스마스 전에는 첫눈이 내린다죠.(한국한정)",
            heartCountText: "1", isOnHeart: true, isFirstReply: false),
      .init(id: 2, userProfileURL: "tempProfile4", userName: "당근당근당근",
            timestamp: "2일전", comment: "재즈 : )", heartCountText: "293", isOnHeart: true, isFirstReply: false)]
    
    return [
      .init(id: 0, userProfileURL: "tempProfile1", userName: "졸업까지 약 세달",
            timestamp: "3일 전", comment: "뭔가 내년이 너무 빨리 다가오는 느낌이드네... 이상하다 이상해!!!!!!! ",
            isOnHeart: true, heartCountText: "1", replies: repliesAboutFirstComment),
      .init(id: 1, userProfileURL: "tempProfile2", userName: "뿌셔뿌셔꿀맛탱",
            timestamp: "4일 전", 
            comment: 
              """
              오 곧 크리스마스라니~~~~ 크리스마스가 다가오면 대학생활도 끝이네요
              많은 것을 잘 배워갑니다.
              
              
              20학점들었을 때가 엊그제.. 엊그제는 아니긴하네요.(머쓱)
              여행이나 가볼까나~..~\n\n후후후..
              """,
            isOnHeart: false, heartCountText: "", replies: [])]
  }
}
