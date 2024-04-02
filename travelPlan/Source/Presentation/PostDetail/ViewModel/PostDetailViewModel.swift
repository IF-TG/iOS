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
  
  init(post: Post, category: Post.Category, postUseCase: PostUseCase) {
    // TODO: - 포스트를 받았으면, 1개의 글을 포스트들, 이미지들 이렇게 조개고 순위를 부여해야합니다. PostMapper에서 구현해야합니다.
    self.postDetails = PostMapper.toPostDetails(post, category: category)
    self.postUseCase = postUseCase
  }
}

// MARK: - PostDetailViewModelable
extension PostDetailViewModel: PostDetailViewModelable {
  func transform(_ input: PostDetailViewModelInput) -> AnyPublisher<PostDetailViewModelState, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Input's Stream
private extension PostDetailViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] in
        return self?.fetchComments()
          .map { _ -> State in
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

// MARK: - Private Helpers
private extension PostDetailViewModel {
  func convertToString(_ travelMainTheme: TravelMainThemeType, subTheme : String) -> String {
    "\(travelMainTheme.rawValue) > \(subTheme)"
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
   
  var cateogry: String {
    var categoryString = ""
    let themes = postDetails.category.themes.map { theme in theme.rawValue }
    let partners = postDetails.category.partners.map { partner in partner.rawValue }
    let seasons = postDetails.category.seasons.map { season in season.rawValue }
    let regions = postDetails.category.regions.map { region in region.rawValue }
    
    if let subTheme = themes.first { categoryString += convertToString(.travelTheme(nil), subTheme: subTheme) }
    if let subTheme = partners.first { categoryString += " , \(convertToString(.partner(nil), subTheme: subTheme))" }
    if let subTheme = seasons.first { categoryString += " , \(convertToString(.season(nil), subTheme: subTheme))" }
    if let subTheme = regions.first { categoryString += " , \(convertToString(.region(nil), subTheme: subTheme))" }
    
    return categoryString
  }
  
  var profileAreaItem: PostDetailProfileAreaInfo {
    let tripDate = postDetails.detail.tripDate
    let tripDurationYMDString = "\(tripDate.start) ~ \(tripDate.end)"
    // FIXME: - 이거도 서버에서 문자열의 start, end받을 때 형식 지정해가지구 몇박 몇일인지를 뜻하는 것고 구하도록 계획해야합니다.
    return .init(
      userName: postDetails.author.nickname,
      userThumbnailPath: postDetails.author.profileUri,
      travelDuration: tripDurationYMDString,
      travelCalendarDateRange: "일박 이일~", uploadedDescription: postDetails.detail.createAt)
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
