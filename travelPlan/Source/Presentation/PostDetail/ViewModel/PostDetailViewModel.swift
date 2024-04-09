//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation
import Combine

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
  // MARK: - Nested
  @frozen enum CommentUseCaseInput {
    case send(UserInputText)
  }
  
  @frozen enum NestedCommentUseCaseInput {
    case send(UserInputText)
  }
  
  // MARK: - Dependencies
  private let postUseCase: PostUseCase
  
  private let postCommentUseCase: PostCommentUseCase
  
  private let postNestedCommentUseCase: PostNestedCommentUseCase
  
  private let loggedInUserUseCase: LoggedInUserUseCase
  
  private let userBlockUseCase: UserBlockUseCase
  
  // MARK: - Properties
  private let DefaultSectionCount = PostDetailSectionType.defaultNumberOfSections
  
  private var postDetails: PostDetails
  
  private let commentUseCaseHandler = PassthroughSubject<CommentUseCaseInput, Never>()
  
  private let nestedCommentUseCaseHandler = PassthroughSubject<NestedCommentUseCaseInput, Never>()
  
  private let loggedInUserUseCaseHandler = PassthroughSubject<Void, Never>()
  
  private let postReportHandler = PassthroughSubject<PostReportType, Never>()
  
  private let postAuthorBlockHandler = PassthroughSubject<Void, Never>()
  
  /// 사용자가 대댓글 작성중인 경우 not nil. 댓글을 작성중인 경우 nil
  private var replyingSection: Int?
  
  private var postReportResultOption: PostDetailOption? = .none
  
  private var actions: PostDetailViewModelActions?
  
  // MARK: - Paging Properties
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
  
  // MARK: - Lifecycle
  init(
    post: Post,
    category: Post.Category,
    postUseCase: PostUseCase,
    postCommentUseCase: PostCommentUseCase,
    loggedInUserUseCase: LoggedInUserUseCase,
    postNestedCommentUseCase: PostNestedCommentUseCase,
    userBlockUseCase: UserBlockUseCase
  ) {
    // TODO: - 포스트를 받았으면, 1개의 글을 포스트들, 이미지들 이렇게 조개고 순위를 부여해야합니다. PostMapper에서 구현해야합니다.
    self.postDetails = PostMapper.toPostDetails(post, category: category)
    self.postUseCase = postUseCase
    self.postCommentUseCase = postCommentUseCase
    self.loggedInUserUseCase = loggedInUserUseCase
    self.postNestedCommentUseCase = postNestedCommentUseCase
    self.userBlockUseCase = userBlockUseCase
  }
}

// MARK: - PostDetailCoordinatorDelegate
extension PostDetailViewModel: PostDetailCoordinatorDelegate {
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    actions?.showAlertForError(description, completion)
  }
  
  func showAnAlertToAskWhetherToCancelWrittingTheReply(completion: ((Bool) -> Void)?) {
    actions?.showAnAlertToAskWhetherToCancelWrittingTheReply(completion)
  }
  
  func showOption(handler: ((PostDetailOption) -> Void)?) {
    actions?.showOption(handler)
  }
  
  func showPostAuthorBlock(handler: ((Bool) -> Void)?) {
    actions?.showPostAuthorBlock(postDetails.author.nickname, handler)
  }
  
  func showPostReport(handler: ((PostReportType) -> Void)?) {
    actions?.showPostReport(handler)
  }
  
  func showPostReportResult() {
    guard let postReportResultOption else {
      actions?.showAlertForError("앱 내부 문제가 발생됬습니다.", nil)
      return
    }
    // TODO: - 포스트 차단의 경우 포스트 상세 나간 후에 이 post 제거로직 추가해주기.
    // postReportNotifier, postAuthorBlockNotifier 호출 완료 시점 이 state를 통해. 완료 경고창 보여주기
    // 화면에는 차단한 포스트 안 보이는게 좋음으로.
    actions?.showPostReportResult(postReportResultOption)
    // 차단 한 경우 화면 나가기
    self.postReportResultOption = nil
  }
}

// MARK: - PostDetailViewModelable
extension PostDetailViewModel: PostDetailViewModelable {
  
  func transform(_ input: PostDetailViewModelInput) -> AnyPublisher<PostDetailViewModelState, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      handleCommentInputStream(input),
      commentUseCaseHandlerStream(),
      nestedCommentUseCaseHandlerStream(),
      loggedInUserUseCaseHandlerStream(),
      replyStartNotifierStream(input),
      keyboardDidHideWhenReplyingToMessageNotifierStream(input),
      replyDismissalConfirmationNorifierStream(input),
      postReportNotifierStream(input),
      postAuthorBlockNotifierStream(input),
      postReportHandlerStream(),
      postAuthorBlockHandlerStream()
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Input's Stream
private extension PostDetailViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] in
        self?.loggedInUserUseCaseHandler.send()
        return self?.fetchCommentsWhenViewDidLoad() ?? Just(
          State.unexpectedError(
            description: ReferenceError.invalidReference.localizedDescription)
        ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func handleCommentInputStream(_ input: Input) -> Output {
    input.commentSendHandler
      .map { [weak self] userInputText -> State in
        DispatchQueue.global(qos: .userInitiated).async {
          if self?.replyingSection != nil {
            /// 대댓글인 경우
            self?.nestedCommentUseCaseHandler.send(.send(userInputText))
          } else {
            /// 댓글인 경우
            self?.commentUseCaseHandler.send(.send(userInputText))
          }
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  /// 커맨트 유즈케이스 관련 전반적인 역할 담당.
  func commentUseCaseHandlerStream() -> Output {
    commentUseCaseHandler
      .flatMap { [weak self] useCaseInput in
        switch useCaseInput {
        case .send(let text):
          return self?.sendCommentStream(with: text) ?? Just(
            State.unexpectedError(description: "댓글을 전송할 수 없습니다.")
          ).eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }
  
  func nestedCommentUseCaseHandlerStream() -> Output {
    return nestedCommentUseCaseHandler
      .flatMap { [weak self] useCaseInput in
        switch useCaseInput {
        case .send(let text):
          return self?.sendNestedCommentStream(with: text) ?? Just(
            State.unexpectedError(description: "대댓글을 전송할 수 없습니다.")
          ).eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }
  
  func loggedInUserUseCaseHandlerStream() -> Output {
    loggedInUserUseCaseHandler.map { [weak self] _ -> State in
      guard let profileURL = self?.loggedInUserUseCase.profileURL else {
        // 로그인한 사용자의 프로필 확인x.. (맨 처음에 로그인할때 기본 이미지 지정하는게 베스트)
        return .unexpectedError(description: "로그인한 사용자의 프로필 이미지가 없습니다.")
      }
      return .viewDidLoad(.loggedInUserInfo(userProfile: profileURL))
    }.eraseToAnyPublisher()
  }
  
  func replyStartNotifierStream(_ input: Input) -> Output {
    input.replyStartNotifier.map { [weak self] replySection -> State in
      self?.replyingSection = replySection
      return .nestedComment(.keyboardState(.willShow))
    }.eraseToAnyPublisher()
  }
  
  func keyboardDidHideWhenReplyingToMessageNotifierStream(_ input: Input) -> Output {
    return input.keyboardDidHideWhenReplyingToMessageNotifier
      .map { [weak self] wannaCancel -> State in
        if wannaCancel {
          self?.clearNestedCommentState()
          return .nestedComment(.replyCancel)
        }
        return .nestedComment(.replyContinue)
      }.eraseToAnyPublisher()
  }
  
  func replyDismissalConfirmationNorifierStream(_ input: Input) -> Output {
    return input.replyDismissalConfirmationNorifier
      .map { [weak self] _ -> State in
        if self?.replyingSection != nil {
          return .nestedComment(.replyCancellationAsk)
        }
        return .none
      }.eraseToAnyPublisher()
  }
  
  func postReportNotifierStream(_ input: Input) -> Output {
    return input.postReportNotifier
      .map { reportType -> State in
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          self?.postReportHandler.send(reportType)
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func postAuthorBlockNotifierStream(_ input: Input) -> Output {
    return input.postAuthorBlockNotifier
      .map { _ -> State in
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          self?.postAuthorBlockHandler.send()
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func postReportHandlerStream() -> Output {
    return postReportHandler.flatMap { responseType in
      // TODO: - 포스트 신고하기 api 없음.
      // 참고로 지금시점 네트워크 프로세싱 중..
      return Just(State.unexpectedError(description: "포스트 신고하기 api가 없습니다."))
        .eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  func postAuthorBlockHandlerStream() -> Output {
    return postAuthorBlockHandler.flatMap { _ in
      // TODO: - 포스트 받아올때 포스트 올린 author에 identifier가 없어서
      // block user api 호출 불가..
      // let authorId = postDetails.author
      
      // 참고로 지금시점 네트워크 프로세싱 중..
      return Just(State.unexpectedError(description: "포스트 저자 id가 없어 차단 api 호출할 수 없습니다")).eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  // MARK: - Inner stream
  /// 초기 viewDidLoad시점에 호출해야 합니다. -> post favorite여부파악.
  func fetchCommentsWhenViewDidLoad() -> Output {
    let postCommentRequestValue = PostCommentsRequestValue(
      page: currentPage,
      perPage: perPage,
      postId: postDetails.detail.postID)
    return postUseCase.fetchComments(with: postCommentRequestValue)
      .map {[weak self] postCommentContainerEntity -> State in
        self?.postDetails.isFavorite = postCommentContainerEntity.isFavorited
        self?.postDetails.comments += postCommentContainerEntity.comments
        return .viewDidLoad(.reloadedCommentsWithPostFavoriteInfo(postCommentContainerEntity.isFavorited))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  /// 댓글 전송할 때
  func sendCommentStream(with text: String) -> Output {
    postCommentUseCase.sendComment(postId: postDetails.detail.postID, comment: text)
      .map { [weak self] postCommentEntity -> State in
        self?.postDetails.comments.append(postCommentEntity)
        return .comment(.reloadedComment)
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  /// 대댓글 전송할 때
  func sendNestedCommentStream(with text: String) -> Output {
    guard let replyingSection else {
      return Just(State.unexpectedError(description: "대댓글을 전송할 수 없습니다.")).eraseToAnyPublisher()
    }
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentId = Int64(replyingSection - PostDetailSectionType.defaultNumberOfSections)
    return postNestedCommentUseCase
      .sendNestedComment(commentId: commentId, comment: text)
      .map { [weak self] postNestedCommentEntity -> State in
        self?.postDetails.comments[Int(commentId)].nestedComments.append(postNestedCommentEntity)
        self?.clearNestedCommentState()
        /// 대댓글이 속한 댓글 섹션은 replyingSection을 보내주어야 합니다.
        return .nestedComment(.sentSuccessfully(replyingSection))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
}

// MARK: - Public Helpers
extension PostDetailViewModel {
  func makeActions(actions: PostDetailViewModelActions?) {
    self.actions = actions
  }
}

// MARK: - Private Helpers
private extension PostDetailViewModel {
  func convertToString(_ travelMainTheme: TravelMainThemeType, subTheme: String) -> String {
    "\(travelMainTheme.rawValue) > \(subTheme)"
  }
  
  func clearNestedCommentState() {
    replyingSection = nil
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
   
  // MARK: - 특정 서브 카테고리에서 여러 개 고를 경우 그중 맨 처음 카테고리 타입만 보여주도록 우선 반환했습니다.
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
  
  func postContentItem(at row: Int) -> PostContentEntity {
    return postDetails.detail.content[row]
  }
  
  var numberOfSections: Int {
    return DefaultSectionCount + postDetails.comments.count
  }
  
  func numberOfRows(in section: Int) -> Int {
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
