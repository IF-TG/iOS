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
  let comments: [[Int]]
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

final class PostDetailViewModel {
  private var postDetails: PostDetails?
  
  init() {
    postDetails = fetchMockAllData()
  }
}

// MARK: - PostDetailTableViewDataSource
extension PostDetailViewModel: PostDetailTableViewDataSource {
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
    guard let postDetails else { return 0 }
    return 2 + postDetails.comments.count
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
      return postDetails.comments[section].count
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
      postContents: contents, category: "여행테마 > 휴식, 동반자 > 가족 ...",
      comments: [])
  }
}
