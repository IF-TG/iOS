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
  case postHeartAndShareArea
  /// 2 이상부터는 comments가 있습니다.
  case comments
  
  init?(rawValue: Int) {
    switch rawValue {
    case 0:
      self = .postDescription
    case 1:
      self = .postContent
    case 2:
      self = .postHeartAndShareArea
    default:
      self = .comments
    }
  }
  
  static let defaultNumberOfSections = 3
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
  private let DefaultSectionCount = PostDetailSectionType.defaultNumberOfSections
  
  private var postDetails: PostDetails?
  
  private var comments: [PostComment] = []
  
  init() {
    postDetails = fetchMockAllData()
    comments = fetchMockAllComments()
  }
  
  // MARK: - Mock Helpers
  func appendComment(_ text: String) {
    let comment = PostComment(
      id: 23,
      userProfileURL: "tempProfile3",
      userName: "신짱구",
      timestamp: "방금",
      comment: text,
      isOnHeart: false,
      heartCountText: "0",
      replies: [])
    comments.append(comment)
  }
}

// MARK: - PostDetailTableViewDataSource
extension PostDetailViewModel: PostDetailTableViewDataSource {
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo {
    let postReply = comments[indexPath.section - DefaultSectionCount].replies[indexPath.row]
    let commentInfo = BasePostDetailCommentInfo(
      commentId: postReply.id,
      userName: postReply.userName,
      userProfileURL: postReply.userProfileURL,
      timestamp: postReply.timestamp,
      comment: postReply.comment,
      isOnHeart: postReply.isOnHeart,
      heartCountText: postReply.heartCountText)
    return .init(
      isFirstReply: postReply.isFirstReply,
      commentInfo: commentInfo)
  }
  
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
    case .postHeartAndShareArea:
      return 0
    default:
      return comments[section-DefaultSectionCount].replies.count
    }
  }
}

private extension PostDetailViewModel {
  func fetchMockAllData() -> PostDetails {    
    let texts: [String] = [
      """
      이제 12월이라고 거리 여기저기서 크리스마스 음악이 흘러나오네요. 크리스마스 트리도 장식한 곳이 많더라구요.
      
      2023년이 오고 캡스톤 디자인으로 엄청 대박인 어플을 만들어보자고 얘기한 게 엊그제 같은데,,
      세월이 너무 빨리 지나간다는게 느껴집니다.
      """,
      """
      근데 진짜 평소보다 도시 분위기도 들떠있고, 볼거리나 즐길거리도 더 많아지는 만큼, 겨울유럽여행 가신다면
      크리스마스때를 노려서 가시라고 추천드릴게요!!
      이제 얼마 안남았기 때문에, 고민은 신중하게 결정은 빠르게 하셔야 할 때랍니다 ㅎ_ㅎ
      """,
      """
      흔히 비엔나 커피로 알고 있는 오스트리아 전통 커피의 정식 명칭은 아인슈페너!
      블랙 커피 위에 휘핑 크림을 얹어 나오는 아인슈페너는 오스트리아어로 ‘말 한 마리가 끄는 마차’ 라는 뜻입니다.
      마차를 타고 다녔던 마부들이 따뜻한 커피를 오랫동안 즐길 수 있도록 생크림을 듬뿍 얹어 마신 것이 지금의 아인슈페너가 된 것이죠.
      """,
      """
      여행 중 마주한 여러 순간들 가운데서도 가장 기억에 남았던 파스타는 정말 특별한 경험이었습니다.\n\n
      그 맛, 향, 그리고 함께한 분위기가 모두 어울려 참으로 특별한 순간을 만들어주었습니다.
      그 파스타는 마치 여행의 하이라이트 같은 느낌이었어요.
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
              
              
              The exact layout varies depending on the stack view’s axis,
              distribution, alignment, spacing, and other properties.
              """
            , heartCountText: "", isOnHeart: false, isFirstReply: true),
      .init(id: 1, userProfileURL: "tempProfile3", userName: "흰눈 펑펑",
            timestamp: "2일전", comment: "오 그럽시다. 크리스마스 전에는 첫눈이 내린다죠.(한국한정)",
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
