//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation
import Combine

struct PostDetailViewModelInput {
  let viewDidLoad = PassthroughSubject<Void, Never>()
}

@frozen enum PostDetailViewModelState {
  case networkProcessing
  case reloadedData
  case reloadedComment
  case unexpectedError(description: String)
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

final class PostDetailViewModel {
  
  // MARK: - Properties
  private let DefaultSectionCount = PostDetailSectionType.defaultNumberOfSections
  
  private var postDetails: PostDetails
  
  private let postUseCase: PostUseCase
  
  // TODO: - 페이징 추가해야합니다. 
  // 그런데 댓글의 경우 좀 복잡할거같은데,, 사용자가 삭제하면 어떻게하지? 기존에 저장된 정보(이미 페이징 한 데이터)가
  // 확실하다는 보장이 없을거같은데 페이징 보다는 맞으려나?
  private var isPaging: Bool = false
  
  private let perPage: Int32 = 15
  
  private var currentPage: Int32 = 0
  
  private var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  // 서버에서 얻어와야 합니다.
  private var totalCommentCount: Int32 = 0
  
  private var hasMorePages: Bool {
    let totalPageCount = totalCommentCount/perPage
    return currentPage < totalPageCount
  }
  
  init(post: Post, category: PostCategory, postUseCase: PostUseCase) {
    // TODO: - 포스트를 받았으면, 1개의 글을 포스트들, 이미지들 이렇게 조개고 순위를 부여해야합니다. PostMapper에서 구현해야합니다.
    self.postDetails = PostMapper.toPostDetails(post, category: category)
    self.postUseCase = postUseCase
  }
  
  // MARK: - Mock Helpers
//  func appendComment(_ text: String) {
//    let comment = PostComment(
//      id: 23,
//      userProfileURL: "tempProfile3",
//      userName: "신짱구",
//      timestamp: "방금",
//      comment: text,
//      isOnHeart: false,
//      heartCountText: "0",
//      replies: [])
//    comments.append(comment)
//  }
}

// MARK: - PostDetailViewModelable
extension PostDetailViewModel: PostDetailViewModelable {
  func transform(_ input: PostDetailViewModelInput) -> AnyPublisher<PostDetailViewModelState, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension PostDetailViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] in
        return self?.fetchComments()
          .map{ _ -> State in
            return .reloadedData
          }.catch {
            return Just(State.unexpectedError(description: $0.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 중 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func fetchComments() -> AnyPublisher<Void, Error> {
    let postCommentRequestValue = PostCommentsRequestValue(
      page: currentPage,
      perPage: perPage,
      postId: postDetails.detail.postID)
    return postUseCase.fetchComments(with: postCommentRequestValue)
      .map {[weak self] postCommentContainerEntity in
        self?.postDetails.isFavorite = postCommentContainerEntity.isFavorited
        self?.postDetails.comments += postCommentContainerEntity.comments
      }.eraseToAnyPublisher()
  }
}

// MARK: - PostDetailTableViewDataSource
extension PostDetailViewModel: PostDetailTableViewDataSource {
  var authorUserId: Int32 {
    // FIXME: - 서버에서 포스트 올린 사용자의 id는 주지 않도록 설계했습니다.
    return -1
  }
  
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo {
    let postComment = postDetails.comments[indexPath.section - DefaultSectionCount]
    let postReply = postComment.nestedComments[indexPath.row]
    
    let commentInfo = BasePostDetailCommentInfo(
      commentId: postReply.nestedCommentId,
      userName: postReply.nickname,
      userProfileURL: postReply.userProfileURL,
      timestamp: postReply.timestamp,
      comment: postReply.comment,
      isOnHeart: postReply.isOnHeart,
      heartCountText: "\(postReply.hearts)")
    return .init(
      isFirstReply: postComment.nestedComments.count == 1,
      commentInfo: commentInfo)
  }
  
  func commentItem(in section: Int) -> BasePostDetailCommentInfo {
    let postComment = postDetails.comments[section - DefaultSectionCount]
    return .init(
      commentId: postComment.commentId,
      userName: postComment.userName,
      userProfileURL: postComment.userProfileURL,
      timestamp: postComment.timestamp,
      comment: postComment.comment,
      isOnHeart: postComment.isOnHeart,
      heartCountText: "\(postComment.hearts)")
  }
  
  var title: String {
    return postDetails.detail.title
  }
  
  // TODO: - 추후에 이거 음? 음. 수정바람.
  var cateogry: String {
    return "\(postDetails.category)"
  }
  
  var profileAreaItem: PostDetailProfileAreaInfo {
    let tripDate = postDetails.detail.tripDate
    let tripDurationYMDString = "\(tripDate.start) ~ \(tripDate.end)"
    // FIXME: - 이거도 서버에서 문자열의 start, end받을 때 형식 지정해가지구 몇박 몇일인지를 뜻하는 것고 구하도록 계획해야합니다.
    return .init(
      userName: postDetails.author.nickname,
      userThumbnailPath: postDetails.author.profileUri,
      travelDuration: tripDurationYMDString,
      travelCalendarDateRange: "", uploadedDescription: postDetails.detail.createAt)
  }
  
  func postContentItem(at row: Int) -> PostDetailContentType {
    return postDetails.detail.content[row]
  }
  
  var numberOfSections: Int {
    return DefaultSectionCount + postDetails.comments.count
  }
  
  func numberOfItems(in section: Int) -> Int {
    let sectionType: PostDetailSectionType = .init(rawValue: section) ?? .postContent
    switch sectionType {
    case .postDescription:
      return 1
    case .postContent:
      return postDetails.detail.content.count
    case .postHeartAndShareArea:
      return 0
    default:
      return postDetails.comments[section-DefaultSectionCount].nestedComments.count
    }
  }
}

/// 이거이거이거!!
//struct mockDataPostDetailViewModel {
//  func fetchMockAllData() -> PostDetails {
//    let texts: [String] = [
//      """
//      이제 12월이라고 거리 여기저기서 크리스마스 음악이 흘러나오네요. 크리스마스 트리도 장식한 곳이 많더라구요.
//      
//      2023년이 오고 캡스톤 디자인으로 엄청 대박인 어플을 만들어보자고 얘기한 게 엊그제 같은데,,
//      세월이 너무 빨리 지나간다는게 느껴집니다.
//      """,
//      """
//      근데 진짜 평소보다 도시 분위기도 들떠있고, 볼거리나 즐길거리도 더 많아지는 만큼, 겨울유럽여행 가신다면
//      크리스마스때를 노려서 가시라고 추천드릴게요!!
//      이제 얼마 안남았기 때문에, 고민은 신중하게 결정은 빠르게 하셔야 할 때랍니다 ㅎ_ㅎ
//      """,
//      """
//      흔히 비엔나 커피로 알고 있는 오스트리아 전통 커피의 정식 명칭은 아인슈페너!
//      블랙 커피 위에 휘핑 크림을 얹어 나오는 아인슈페너는 오스트리아어로 ‘말 한 마리가 끄는 마차’ 라는 뜻입니다.
//      마차를 타고 다녔던 마부들이 따뜻한 커피를 오랫동안 즐길 수 있도록 생크림을 듬뿍 얹어 마신 것이 지금의 아인슈페너가 된 것이죠.
//      """,
//      """
//      여행 중 마주한 여러 순간들 가운데서도 가장 기억에 남았던 파스타는 정말 특별한 경험이었습니다.\n\n
//      그 맛, 향, 그리고 함께한 분위기가 모두 어울려 참으로 특별한 순간을 만들어주었습니다.
//      그 파스타는 마치 여행의 하이라이트 같은 느낌이었어요.
//      """]
//    let contents: [PostDetailContentType] = [
//      .text(texts[0]), .image("tempThumbnail6"),
//      .text(texts[1]), .image("tempThumbnail7"),
//      .text(texts[2]), .image("tempThumbnail8"), .text(texts[3])]
//    
//    return .init(
//      postId: 0, userName: "닉네임은 여덟자리", userId: 0,
//      isFavoritePost: false, userThumbnailPath: "tempProfile1",
//      travelDuration: "1박 2일", travelCalenderDateRange: "23.12.31 ~ 23.12.31",
//      uploadedDescription: "2023. 12. 31 12:12", title: "곧 크리스마스가 다가옵니다. 하하하. 미리메리크리스마스~",
//      postContents: contents, category: "여행테마 > 휴식, 동반자 > 가족 ...")
//  }
//  
//  func fetchMockAllComments() -> [PostComment] {
//    let repliesAboutFirstComment: [PostReply] = [
//      .init(id: 0, userProfileURL: "tempProfile2", userName: "나야나 스택뷰 설명!",
//            timestamp: "2일전", comment:
//              """
//              Stack views let you leverage the power of Auto Layout,
//              creating user interfaces that can dynamically adapt to the device’s orientation,
//              screen size, and any changes in the available space.
//              
//              The stack view manages the layout of all the views in its arrangedSubviews property.
//              These views are arranged along the stack view’s axis, based on their order in the arrangedSubviews array.
//              
//              
//              The exact layout varies depending on the stack view’s axis,
//              distribution, alignment, spacing, and other properties.
//              """
//            , heartCountText: "", isOnHeart: false, isFirstReply: true),
//      .init(id: 1, userProfileURL: "tempProfile3", userName: "흰눈 펑펑",
//            timestamp: "2일전", comment: "오 그럽시다. 크리스마스 전에는 첫눈이 내린다죠.(한국한정)",
//            heartCountText: "1", isOnHeart: true, isFirstReply: false),
//      .init(id: 2, userProfileURL: "tempProfile4", userName: "당근당근당근",
//            timestamp: "2일전", comment: "재즈 : )", heartCountText: "293", isOnHeart: true, isFirstReply: false)]
//    
//    return [
//      .init(id: 0, userProfileURL: "tempProfile1", userName: "졸업까지 약 세달",
//            timestamp: "3일 전", comment: "뭔가 내년이 너무 빨리 다가오는 느낌이드네... 이상하다 이상해!!!!!!! ",
//            isOnHeart: true, heartCountText: "1", replies: repliesAboutFirstComment),
//      .init(id: 1, userProfileURL: "tempProfile2", userName: "뿌셔뿌셔꿀맛탱",
//            timestamp: "4일 전", 
//            comment: 
//              """
//              오 곧 크리스마스라니~~~~ 크리스마스가 다가오면 대학생활도 끝이네요
//              많은 것을 잘 배워갑니다.
//              
//              
//              20학점들었을 때가 엊그제.. 엊그제는 아니긴하네요.(머쓱)
//              여행이나 가볼까나~..~\n\n후후후..
//              """,
//            isOnHeart: false, heartCountText: "", replies: [])]
//  }
//}
