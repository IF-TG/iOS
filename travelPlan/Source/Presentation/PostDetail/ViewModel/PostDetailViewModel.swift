//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation
import Combine

enum PostDetailSection: Int {
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
  
  static func commentIndex(section: Int) -> Int {
    section - defaultNumberOfSections
  }
}

final class PostDetailViewModel {
  typealias SectionType = PostDetailSection
  
  // MARK: - Nested
  @frozen enum CommentUseCaseInput {
    case send(UserInputText)
    case edit(UserInputText)
    case delete(Section)
  }
  
  @frozen enum NestedCommentUseCaseInput {
    case send(UserInputText)
    case edit(UserInputText)
    case delete(IndexPath)
  }
  
  // MARK: - Dependencies
  private let postUseCase: PostUseCase
  
  private let postCommentUseCase: PostCommentUseCase
  
  private let postNestedCommentUseCase: PostNestedCommentUseCase
  
  private let loggedInUserUseCase: LoggedInUserUseCase
  
  private let userBlockUseCase: UserBlockUseCase
  
  // MARK: - Properties
  private var postDetails: PostDetails
  
  private let commentUseCaseNotifier = PassthroughSubject<CommentUseCaseInput, Never>()
  
  private let commentUseCaseHandler = PassthroughSubject<CommentUseCaseInput, Never>()
  
  private let commentEditNotifier = PassthroughSubject<Int, Never>()
  
  private let nestedCommentUseCaseNotifier = PassthroughSubject<NestedCommentUseCaseInput, Never>()
  
  private let nestedCommentUseCaseHandler = PassthroughSubject<NestedCommentUseCaseInput, Never>()
  
  private let nestedCommentEditNotifier = PassthroughSubject<IndexPath, Never>()
  
  private let loggedInUserUseCaseHandler = PassthroughSubject<Void, Never>()
   
  private let postReportNotifier = PassthroughSubject<PostReportType, Never>()
  
  private let postReportHandler = PassthroughSubject<PostReportType, Never>()
  
  private let postAuthorBlockNotifier = PassthroughSubject<Void, Never>()
  
  private let postAuthorBlockHandler = PassthroughSubject<Void, Never>()
  
  private let navigationInfo = PassthroughSubject<Void, Never>()

  private let keyboardDidHideHandler = PassthroughSubject<(PostDetailWritingCacnelType, Bool), Never>()
  
  /// 사용자가 대댓글 작성중인 경우 not nil. 댓글을 작성중인 경우 nil
  private var replyingSection: Int?
  
  /// 사용자가 대댓글 수정중인 경우 not nil. 댓글을 수정하지 않을 경우 nil
  private var editingNestedCommentIndexPath: IndexPath?
  
  /// 사용자가 댓글 수정중인 경우 not nil, 댓글을 수정하지 않는 일반적인 경우 nil
  private var editingCommentSection: Int?
  
  private let actions: PostDetailViewModelActions?
  
  private var postReportResultOption: PostDetailOption? = .none
  
  private var post: Post?
  
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
    userBlockUseCase: UserBlockUseCase,
    actions: PostDetailViewModelActions?
  ) {
    // TODO: - 포스트를 받았으면, 1개의 글을 포스트들, 이미지들 이렇게 조개고 순위를 부여해야합니다. PostMapper에서 구현해야합니다.
    self.postDetails = PostMapper.toPostDetails(post, category: category)
    self.postUseCase = postUseCase
    self.postCommentUseCase = postCommentUseCase
    self.loggedInUserUseCase = loggedInUserUseCase
    self.postNestedCommentUseCase = postNestedCommentUseCase
    self.userBlockUseCase = userBlockUseCase
    self.actions = actions
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - PostDetailViewModelPageDelegate
extension PostDetailViewModel: PostDetailViewModelPageDelegate {
  func showReviewWriting() {
    let postContents = postDetails.detail.content
    let reviewWritingEntity = ReviewWritingEntity(
      postId: postDetails.detail.postID,
      category: postDetails.category,
      tripDate: postDetails.detail.tripDate,
      title: postDetails.detail.title,
      contents: postContents
    )
    actions?.showReviewWriting(reviewWritingEntity)
  }
  
  func showCommentOption(section: Int) {
    let commentSection = SectionType.commentIndex(section: section)
    // TODO: - 아.. 댓글 작성자의 id가 있어야 하지만 entity에 없습니다.
    let comment = postDetails.comments[commentSection]
    guard let loggedUserId = loggedInUserUseCase.id else {
      showAlertForError(with: "로그인 한 사용자만 이용 가능합니다.", completion: nil)
      return
    }
    // TODO: - 로그인한 사용자가 작성한 댓글인지 여부에 따라 사용자 신고 기능만 추가될건지, 댓글 삭제, 수정 기능만 추가될 것인지..
    // 만약 자신이라면, 삭제, 수정 기능
    // 만약 타인꺼 댓글이라면 신고 기능만,,,
    // 신고 기능 api도 없음으로 일단 자신꺼에 한정해 삭제, 수정 기능만 넣고 자신것이 아니라면 알림창으로 본인만 수정 가능하다고 보여주어야 합니다.
    let commentUploadedUserId = loggedUserId
    actions?.showCommentOption(loggedUserId == commentUploadedUserId) { [weak self] commentOption in
      switch commentOption {
      case .commentDelete:
        self?.commentUseCaseNotifier.send(.delete(section))
      case .commentUpdate:
        // MARK: - 업데이트는 로직을 isCommentUpdating 이걸 추가하면서 대댓글 작성 과 같게 로직을 짜야 합니다.
        // self?.commentUseCaseNotifier.send(.update(section))
        self?.commentEditNotifier.send(section)
      case .commentUserBlock:
        self?.showAlertForError(with: "댓글 차단 기능은 다음 업데이트 때 구현될 예정입니다.", completion: nil)
      }
    }
  }
  
  func showNestedCommentOption(indexPath: IndexPath) {
    let commentSection = SectionType.commentIndex(section: indexPath.section)
    // TODO: - 아.. nestedCommentEntity에 대댓 작성한 UserId가 있어야 하지만 entity에 없습니다.
    let nestedComment = postDetails.comments[commentSection].nestedComments[indexPath.row]
    
    guard let loggedUserId = loggedInUserUseCase.id else {
      showAlertForError(with: "로그인 한 사용자만 이용 가능합니다.", completion: nil)
      return
    }
    
    // TODO: - 로그인한 사용자가 작성한 댓글인지 여부에 따라 사용자 차단 기능만 추가될건지, 댓글 삭제, 수정 기능만 추가될 것인지..
    // 만약 자신이라면, 삭제, 수정 기능
    // 만약 타인꺼 댓글이라면 차단 기능만,,,
    // 신고 기능 api도 없음으로 일단 자신꺼에 한정해 삭제, 수정 기능만 넣고 자신것이 아니라면 알림창으로 보여주어야 합니다.
    let commentUploadedUserId = loggedUserId
    actions?.showCommentOption(loggedUserId == commentUploadedUserId) { [weak self] commentOption in
      switch commentOption {
      case .commentDelete:
        self?.nestedCommentUseCaseNotifier.send(.delete(indexPath))
      case .commentUpdate:
        // MARK: - 업데이트는 로직을 isNestedCommentUpdating 이걸 추가하면서 대댓글 작성 과 같게 로직을 짜야 합니다.
        self?.nestedCommentEditNotifier.send(indexPath)
      case .commentUserBlock:
        self?.showAlertForError(with: "대댓글 차단 기능은 다음 업데이트 때 구현될 예정입니다.", completion: nil)
      }
    }
  }
  
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    actions?.showAlertForError(description, completion)
  }
  
  func showPostOption() {
    actions?.showPostOption { [weak self] optionState in
      switch optionState {
      case .postBlock:
        guard let authorNickname = self?.postDetails.author.nickname else {
          self?.showAlertForError(with: "앱 내부 문제가 발생되어 포스트 옵션을 선택할 수 없습니다.", completion: nil)
          return
        }
        self?.actions?.showPostAuthorBlock(authorNickname) { wannaBlock in
          if wannaBlock { self?.postAuthorBlockNotifier.send() }
        }
      case .postReport:
        self?.actions?.showPostReport { reportType in
          if reportType == .stopRequest { return }
          self?.postReportNotifier.send(reportType)
        }
      }
    }
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
  
  func showCategory() {
    let themeTexts = postDetails.category.themes.compactMap { theme in
      "\(TravelMainThemeType.travelTheme(nil).rawValue) > \(theme.rawValue)"
    }
    let seasonTexts = postDetails.category.seasons.compactMap { season in
      "\(TravelMainThemeType.season(nil).rawValue) > \(season.rawValue)"
    }
    let regionTexts = postDetails.category.regions.compactMap { region in
      "\(TravelMainThemeType.region(nil).rawValue) > \(region.rawValue)"
    }
    let partnerTests = postDetails.category.partners.compactMap { partner in
      "\(TravelMainThemeType.partner(nil).rawValue) > \(partner.rawValue)"
    }
    let categories = themeTexts + seasonTexts + regionTexts + partnerTests
    actions?.showCategory(categories)
  }
}

// MARK: - PostDetailViewModelable
extension PostDetailViewModel: PostDetailViewModelable {
  
  func transform(_ input: PostDetailViewModelInput) -> AnyPublisher<PostDetailViewModelState, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      navigationInfoStream(),
      handleCommentInputStream(input),
      commentUseCaseHandlerStream(),
      nestedCommentUseCaseHandlerStream(),
      loggedInUserUseCaseHandlerStream(),
      replyStartNotifierStream(input),
      keyboardDidHideHandlerStream(),
      keyboardDidHideNotifierStream(input),
      postReportNotifierStream(),
      postAuthorBlockNotifierStream(),
      postReportHandlerStream(),
      postAuthorBlockHandlerStream(),
      commentUseCaseNotifierStream(),
      nestedCommentEditNotifierStream(),
      commentEditNotifierStream(),
      nestedCommentUseCaseNotifierStream()
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Input's Stream
private extension PostDetailViewModel {
  func navigationInfoStream() -> Output {
    return navigationInfo.map { [weak self] _ -> State in
      guard let postTitle = self?.postDetails.detail.title else { return .none }
      // TODO: - 34일 이렇게 몇일 구해야합니다.
      //let postDuration = postDetails.detail.tripDate
      let postDuration = "34일 동안의 여정"
      return .viewDidLoad(.naviTitleInfo((postTitle, postDuration)))
    }.eraseToAnyPublisher()
  }
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] in
        self?.navigationInfo.send()
        self?.loggedInUserUseCaseHandler.send()
        return self?.fetchCommentsWhenViewDidLoad() ?? Just(
          State.unexpectedError(
            description: ReferenceError.invalidReference.localizedDescription)
        ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  /// CommnetInput에서 send가 눌러질 경우. 댓글, 대댓글 작성 및 수정 등 전송 관련 로직 담당
  func handleCommentInputStream(_ input: Input) -> Output {
    input.commentSendHandler
      .map { [weak self] userInputText -> State in
        DispatchQueue.global(qos: .userInitiated).async {
          /// 대댓글인 작성 후 전송할 것인가?
          let isReplyWrittenForSend = self?.replyingSection != nil
          /// 대댓글 수정 후 전송할 것인가?
          let isReplyWrittenForEdit = self?.editingNestedCommentIndexPath != nil
          /// 댓글 수정 후 전송할 것인가?
          let isCommentWrittenForEdit = self?.editingCommentSection != nil
          
          if isReplyWrittenForSend {
            self?.nestedCommentUseCaseHandler.send(.send(userInputText))
          } else if isReplyWrittenForEdit {
            self?.nestedCommentUseCaseHandler.send(.edit(userInputText))
          } else if isCommentWrittenForEdit {
            self?.commentUseCaseHandler.send(.edit(userInputText))
          } else {
            // 일반적으로 댓글 작성시 호출됩니다.
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
        case .edit(let userInputText):
          return self?.updateCommentStream(with: userInputText) ?? Just(
            State.unexpectedError(description: "댓글을 수정할 수 없습니다.")
          ).eraseToAnyPublisher()
        case .delete(let section):
          return self?.deleteCommentStream(with: section) ?? Just(
            State.unexpectedError(description: "댓글을 삭제할 수 없습니다.")
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
        case .edit(let editedText):
          return self?.updateNestedCommentStream(with: editedText) ?? Just(
            State.unexpectedError(description: "대댓글 편집에 실패했습니다.")
          ).eraseToAnyPublisher()
        case .delete(let indexPath):
          return self?.deleteNestedCommentStream(with: indexPath) ?? Just(
            State.unexpectedError(description: "앱 내부 에러가 발생됬습니다.대댓글을 삭제할 수 없습니다.")
          ).eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }
  
  /// 옵션에서 편집하기가 될 경우 키보드 보여주는 로직
  func nestedCommentEditNotifierStream() -> Output {
    return nestedCommentEditNotifier
      .map { [weak self] indexPath -> State in
        self?.editingNestedCommentIndexPath = indexPath
        let commentIndex = SectionType.commentIndex(section: indexPath.section)
        guard let comment = self?.postDetails.comments[commentIndex] else {
          return State.unexpectedError(description: "앱 내부 에러가 발생됬습니다. 대댓글을 수정할 수 없습니다.")
        }
        let replyComment = comment.nestedComments[indexPath.row].comment
        return State.keyboard(.willShowWhenCommentEditStart(replyComment))
      }.eraseToAnyPublisher()
  }
  
  func commentEditNotifierStream() -> Output {
    return commentEditNotifier
      .map { [weak self] section -> State in
        self?.editingCommentSection = section
        let commentIndex = SectionType.commentIndex(section: section)
        guard let comment = self?.postDetails.comments[commentIndex] else {
          return State.unexpectedError(description: "앱 내부 에러가 발생됬습니다. 대댓글을 수정할 수 없습니다.")
        }
        return .keyboard(.willShowWhenCommentEditStart(comment.comment))
      }.eraseToAnyPublisher()
  }
  
  func loggedInUserUseCaseHandlerStream() -> Output {
    loggedInUserUseCaseHandler.map { [weak self] _ -> State in
      guard let profileURL = self?.loggedInUserUseCase.profileURL else {
        // 로그인한 사용자의 프로필 확인x.. (맨 처음에 로그인할때 기본 이미지 지정하는게 베스트)
        return .unexpectedError(description: "로그인한 사용자의 프로필 이미지가 없습니다.")
      }
      
      // TODO: - 포스트에 포스트 작성 저자와 비교해야 합니다. Server에는 포스트에 아직 author id가 없음으로 패스..
      guard let loggedUserId = self?.loggedInUserUseCase.id else {
        // 로그인한 사용자의 프로필 확인x.. (맨 처음에 로그인할때 기본 이미지 지정하는게 베스트)
        return .unexpectedError(description: "로그인한 사용자의 프로필 이미지가 없습니다.")
      }
      // 비교로직.postDetails.Author..
      return .viewDidLoad(.loggedInUserInfo(userProfile: profileURL, isPostOwner: true))
    }.eraseToAnyPublisher()
  }
  
  func replyStartNotifierStream(_ input: Input) -> Output {
    input.replyStartNotifier.map { [weak self] replySection -> State in
      self?.replyingSection = replySection
      return .keyboard(.willShow)
    }.eraseToAnyPublisher()
  }
  
  // 댓, 대댓, 등 키보드가 사라질때 여기서 처리합니다
  func keyboardDidHideHandlerStream() -> Output {
    return keyboardDidHideHandler
      .map { [weak self] (writingCancelType, wannaCancel) -> State in
        switch writingCancelType {
        case .replyWrite:
          if wannaCancel {
            self?.replyingSection = nil
            return .keyboard(.hideToWritingCancel)
          }
          return .keyboard(.writingContinue)
        case .replyEdit:
          if wannaCancel {
            self?.editingNestedCommentIndexPath = nil
            return .keyboard(.hideToWritingCancel)
          }
          return .keyboard(.writingContinue)
        case .commentEdit:
          if wannaCancel {
            self?.editingCommentSection = nil
            return .keyboard(.hideToWritingCancel)
          }
          return .keyboard(.writingContinue)
        }
      }.eraseToAnyPublisher()
  }
  
  func keyboardDidHideNotifierStream(_ input: Input) -> Output {
    return input.keyboardHideNotifier
      .map { [weak self] _ -> State in
        let isReplyWrittenForSend = self?.replyingSection != nil
        let isReplyWrittenForEdit = self?.editingNestedCommentIndexPath != nil
        let isCommentWrittenForEdit = self?.editingCommentSection != nil
        
        if isReplyWrittenForSend {
          self?.actions?.showAnAlertToAskWhetherToCancelWriting(.replyWrite) { wannaCancel in
            self?.keyboardDidHideHandler.send((.replyWrite, wannaCancel))
          }
        } else if isReplyWrittenForEdit {
          self?.actions?.showAnAlertToAskWhetherToCancelWriting(.replyEdit) { wannaCancel in
            self?.keyboardDidHideHandler.send((.replyEdit, wannaCancel))
          }
        } else if isCommentWrittenForEdit {
          self?.actions?.showAnAlertToAskWhetherToCancelWriting(.commentEdit) { wannaCancel in
            self?.keyboardDidHideHandler.send((.commentEdit, wannaCancel))
          }
        }
        return .none
      }.eraseToAnyPublisher()
  }
  
  func postReportNotifierStream() -> Output {
    return postReportNotifier
      .map { reportType -> State in
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          self?.postReportHandler.send(reportType)
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  func postAuthorBlockNotifierStream() -> Output {
    return postAuthorBlockNotifier
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
  
  func commentUseCaseNotifierStream() -> Output {
    return commentUseCaseNotifier.map { commentInput -> State in
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.commentUseCaseHandler.send(commentInput)
      }
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
  
  /// 이거 새로 개발한 인디케이터 쓰면 없어질 예정....
  func nestedCommentUseCaseNotifierStream() -> Output {
    return nestedCommentUseCaseNotifier.map { nestedCommentInput -> State in
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.nestedCommentUseCaseHandler.send(nestedCommentInput)
      }
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
}

// MARK: - Transform Inner stream
private extension PostDetailViewModel {
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
  
  // MARK: - Comment Stream
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
  
  func deleteCommentStream(with section: Section) -> Output {
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentSection = SectionType.commentIndex(section: section)
    let commentId = postDetails.comments[commentSection].commentId
    return postCommentUseCase
      .deleteComment(commentId: commentId)
      .map { [weak self] result -> State in
        if result {
          self?.postDetails.comments[commentSection].isDeleted = result
          
          guard let nestedCommentCount = self?.postDetails.comments[commentSection].nestedComments.count else {
            return .unexpectedError(description: "댓글이 삭제되지 않았습니다.")
          }
          
          /// 대댓글 있는 경우
          if nestedCommentCount > 0 {
            return .comment(.reloadWithNestedCommentsWhenCommentDelete(section))
          }
          
          /// 대댓글 없는 경우
          self?.postDetails.comments.remove(at: commentSection)
          return .comment(.reloadWhenCommentDelete(section))
        }
        return .unexpectedError(description: "서버에서 에러가 발생되 댓글이 삭제되지 않았습니다.")
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  func updateCommentStream(with editedText: String) -> Output {
    guard let section = editingCommentSection else {
      return Just(State.unexpectedError(description: "대댓글을 수정할 수 없습니다.")).eraseToAnyPublisher()
    }
    let commentIdx = SectionType.commentIndex(section: section)
    let comment = postDetails.comments[commentIdx]
    return postCommentUseCase
      .updateComment(commentId: comment.commentId, comment: editedText)
      .map { [weak self] result -> State in
        guard result else {
          return .unexpectedError(description: "서버에서 에러가 발생되어 댓글이 편집되지 않았습니다.")
        }
        self?.postDetails.comments[commentIdx].comment = editedText
        self?.editingCommentSection = nil
        return .comment(.reloadWhenCommentUpdate(section))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  // MARK: - Nested Comment Stream
  /// 대댓글 전송할 때
  func sendNestedCommentStream(with text: String) -> Output {
    guard let replyingSection else {
      return Just(State.unexpectedError(description: "대댓글을 전송할 수 없습니다.")).eraseToAnyPublisher()
    }
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentSection = SectionType.commentIndex(section: replyingSection)
    let commentId = postDetails.comments[commentSection].commentId
    return postNestedCommentUseCase
      .sendNestedComment(commentId: commentId, comment: text)
      .map { [weak self] postNestedCommentEntity -> State in
        self?.postDetails.comments[commentSection].nestedComments.append(postNestedCommentEntity)
        self?.replyingSection = nil
        /// 대댓글이 속한 댓글 섹션은 replyingSection을 보내주어야 합니다.
        return .nestedComment(.sentSuccessfully(replyingSection))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  /// 대댓글 삭제
  func deleteNestedCommentStream(with indexPath: IndexPath) -> Output {
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentSection = SectionType.commentIndex(section: indexPath.section)
    let nestedCommentId = postDetails.comments[commentSection].nestedComments[indexPath.row].nestedCommentId
    return postNestedCommentUseCase
      .deleteNestedComment(nestedCommentId: nestedCommentId)
      .map { [weak self] result -> State in
        guard result else {
          return .unexpectedError(description: "서버에서 에러가 발생되 대댓글이 삭제되지 않았습니다.")
        }
        
        self?.postDetails.comments[commentSection].nestedComments.remove(at: indexPath.row)
        
        let isNestedCommentAllRemoved = self?.postDetails
          .comments[commentSection]
          .nestedComments.count == 0
        
        if isNestedCommentAllRemoved {
          self?.postDetails.comments.remove(at: commentSection)
          /// 테이블뷰에 실제로 특정 셀 제거 후 리로드 명령은 실제 indexPath로 해야합니다.
          return .nestedComment(.reloadWhenLastNestedCommentDelete(indexPath))
        }
        /// 테이블뷰에 실제로 특정 셀 제거 후 리로드 명령은 실제 indexPath로 해야합니다.
        return .nestedComment(.reload(indexPath))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  func updateNestedCommentStream(with editedText: String) -> Output {
    guard let indexPath = editingNestedCommentIndexPath else {
      return Just(State.unexpectedError(description: "대댓글을 수정할 수 없습니다.")).eraseToAnyPublisher()
    }
    let commentIdx = SectionType.commentIndex(section: indexPath.section)
    let nestedComment = postDetails.comments[commentIdx].nestedComments[indexPath.row]
    return postNestedCommentUseCase
      .updateNestedComment(nestedCommentId: nestedComment.nestedCommentId, comment: editedText)
      .map { [weak self] result -> State in
        guard result else {
          return .unexpectedError(description: "서버에서 에러가 발생되어 대댓글이 편집되지 않았습니다.")
        }
        self?.postDetails.comments[commentIdx].nestedComments[indexPath.row].comment = editedText
        
        self?.editingNestedCommentIndexPath = nil
        return .nestedComment(.reloadWhenCommentUpdate(indexPath))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension PostDetailViewModel {
  func convertToString(_ travelMainTheme: TravelMainThemeType, subTheme: String) -> String {
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
    let commentIdx = SectionType.commentIndex(section: indexPath.section)
    let postComment = postDetails.comments[commentIdx]
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
      isFirstReply: indexPath.row == 0,
      commentInfo: commentInfo)
  }
  
  func commentItem(in section: Int) -> PostCommentInfo {
    let commentIdx = SectionType.commentIndex(section: section)
    let postComment = postDetails.comments[commentIdx]
    let baseInfo: BasePostDetailCommentInfo = .init(
      commentId: postComment.commentId,
      userName: postComment.userName,
      userProfileURL: postComment.userProfileURL,
      timestamp: postComment.timestamp,
      comment: postComment.isDeleted ? "댓글이 삭제되었습니다." : postComment.comment,
      isOnHeart: postComment.isOnHeart,
      heartCountText: "\(postComment.hearts)")
    return .init(baseInfo: baseInfo, isDeleted: postComment.isDeleted)
    
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
    return SectionType.defaultNumberOfSections + postDetails.comments.count
  }
  
  func numberOfRows(in section: Int) -> Int {
    let sectionType: PostDetailSection = .init(rawValue: section) ?? .postContent
    switch sectionType {
    case .postDescription:
      return 1
    case .postContent:
      return postDetails.detail.content.count
    case .postHeartAndShareArea:
      return 0
    default:
      let commentIdx = SectionType.commentIndex(section: section)
      return postDetails.comments[commentIdx].nestedComments.count
    }
  }
}

extension PostDetailViewModel: ReviewWritingPostReceivable {
  func receive(post: Post) {
    // TODO: - 편집한 리뷰작성 Post를 기반으로 화면을 갱신해야 합니다.
    print("DEBUG: PostDetailViewModel에서 편집된 post 객체 받음")
    self.post = post
  }
}
