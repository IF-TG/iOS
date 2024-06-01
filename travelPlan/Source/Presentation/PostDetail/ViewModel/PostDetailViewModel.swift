//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation
import Combine

@frozen enum PostDetailViewModelError {
  case failedToFetchPostDetails(Error)
}

final class PostDetailViewModel {
  typealias SectionType = PostDetailSection

  // MARK: - Dependencies
  private let postFetchUsecase: PostFetchUseCase
  
  private let ownerRepository: LoggedInUserRepository
  
  private let userBlockUseCase: UserBlockUseCase
  
  // MARK: - Properties
  // TODO: - PostDetails가 굳이 있어야할까? Post로 대체 안될까?
  private var postDetails: PostDetails?
  
  private let postId: Int32
  
  private var postSubscription: AnyCancellable?
  
  private let postDetailsFetchNotifier = PassthroughSubject<Void, Never>()
  
  private let errorHandler = PassthroughSubject<PostDetailViewModelError, Never>()
  
  private let postAuthoommentEditNotifier = PassthroughSubject<IndexPath, Never>()
  
  private let loggedInUserUseCaseHandler = PassthroughSubject<Void, Never>()
  
  private let postReportNotifier = PassthroughSubject<PostReportType, Never>()
  
  private let postReportHandler = PassthroughSubject<PostReportType, Never>()
  
  private let postAuthorBlockNotifier = PassthroughSubject<Void, Never>()
  
  private let postAuthorBlockHandler = PassthroughSubject<Void, Never>()
  
  private let navigationInfo = PassthroughSubject<Void, Never>()
  
  private let actions: PostDetailViewModelActions?
  
  private var postDetailOption: PostDetailOption? = .none
  
  // MARK: - Lifecycle
  init(
    post: Post?,
    postId: Int32,
    postFetchUsecase: PostFetchUseCase,
    ownerRepository: LoggedInUserRepository,
    userBlockUseCase: UserBlockUseCase,
    actions: PostDetailViewModelActions?
  ) {
    if let post = post {
      self.postDetails = PostMapper.toPostDetails(post, category: post.category)
      self.postId = Int32(post.detail.postID) ?? -1
    } else {
      /// postId만 존재한다는 것은 universal link를 통해 공유하기 로직으로 접근된 것입니다.
      self.postId = postId
    }
    self.postFetchUsecase = postFetchUsecase
    self.ownerRepository = ownerRepository
    self.userBlockUseCase = userBlockUseCase
    self.actions = actions
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - PostDetailViewModelPageDelegate
extension PostDetailViewModel: PostDetailViewModelPageDelegate {
  func showAlertAndDismiss(with description: String) {
    showAlertForError(with: description) { [weak self] in
      self?.actions?.finishWithAnim()
    }
  }
  
  func showReviewWriting() {
    guard let postDetails else { return }
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
  
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    actions?.showAlertForError(description, completion)
  }
  
  func showPostOption() {
    actions?.showPostOption { [weak self] optionState in
      self?.postDetailOption = optionState
      switch optionState {
      case .postBlock:
        guard let authorNickname = self?.postDetails?.author.nickname else {
          self?.showAlertForError(with: "앱 내부 문제가 발생되어 포스트 옵션을 선택할 수 없습니다.", completion: nil)
          self?.postDetailOption = nil
          return
        }
        self?.actions?.showPostAuthorBlock(authorNickname) { wannaBlock in
          if wannaBlock {
            self?.postAuthorBlockNotifier.send()
          } else {
            self?.postDetailOption = nil
          }
        }
      case .postReport:
        self?.actions?.showPostReport { reportType in
          if reportType == .stopRequest {
            self?.postDetailOption = nil
            return
          }
          self?.postReportNotifier.send(reportType)
        }
      }
    }
  }
  
  func showPostReportResult() {
    guard let postDetailOption, let postDetails else {
      actions?.showAlertForError("앱 내부 문제가 발생됬습니다.", nil)
      return
    }
    actions?.showPostReportResult(postDetailOption)
    if postDetailOption == .postBlock {
      actions?.showFeedAfterBlockingFeed(Int32(postDetails.detail.postID) ?? -1)
    }
    self.postDetailOption = nil
  }
  
  func showCategory() {
    guard let postDetails else { return }
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
      errorHandlerStream(),
      postDetailsFetchNotifierStream(),
      navigationInfoStream(),
      loggedInUserUseCaseHandlerStream(),
      postReportNotifierStream(),
      postAuthorBlockNotifierStream(),
      postReportHandlerStream(),
      postAuthorBlockHandlerStream()
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Input's Stream
private extension PostDetailViewModel {
  func errorHandlerStream() -> Output {
    return errorHandler.map { errorState -> State in
      switch errorState {
      case .failedToFetchPostDetails(let error):
        return .failedToFetchPost(description: error.localizedDescription)
      }
    }.eraseToAnyPublisher()
  }
  
  /// Universal link에 의해 포스트 상세화면에 접근될 경우 호출되는 stream입니다.
  func postDetailsFetchNotifierStream() -> Output {
    return postDetailsFetchNotifier.map { [weak self] _ -> State in
      self?.navigationInfo.send()
      self?.loggedInUserUseCaseHandler.send()
      return .viewDidLoad(.reloadData)
    }.eraseToAnyPublisher()
  }
  
  func navigationInfoStream() -> Output {
    return navigationInfo.map { [weak self] _ -> State in
      guard
        let postTitle = self?.postDetails?.detail.title,
        let startDate = self?.postDetails?.detail.tripDate.startDate,
        let endDate = self?.postDetails?.detail.tripDate.endDate
      else { return .none }
      let tripPeriod = DateTimeConverter.period(from: startDate, to: endDate)
      let postDuration = "\(tripPeriod)의 여정"
      return .viewDidLoad(.naviTitleInfo((postTitle, postDuration)))
    }.eraseToAnyPublisher()
  }
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ -> State in
        /// postDetails가 nil인 경우는 universal link에의해 접근된 것이므로 서버에서 포스트 내용을 받아와야 합니다.
        if self?.postDetails == nil, let postId = self?.postId {
          self?.fetchPostDetails(with: postId)
          return .networkProcessing
        }
        self?.navigationInfo.send()
        self?.loggedInUserUseCaseHandler.send()
        return .none
      }.eraseToAnyPublisher()
  }
  
  func loggedInUserUseCaseHandlerStream() -> Output {
    loggedInUserUseCaseHandler.map { [weak self] _ -> State in
      /// 로그인한 사용자라면 아이디가 반드시 로컬에 저장되야 합니다.
      guard
        let ownerId = self?.ownerRepository.id,
        let postAuthorId = self?.postDetails?.author.authorId
      else {
        return .unexpectedError(description: "로그인한 사용자의 아이디가 없습니다.")
      }
      return .viewDidLoad(.loggedInUserInfo(
        userProfile: self?.ownerRepository.profileImageData,
        isPostOwner: postAuthorId == ownerId))
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
      print(responseType)
      // 참고로 지금시점 네트워크 프로세싱 중.
      // 여기서 이제 레포지토리로 리포트 사유를 같이 보낸 후에 성공 아님 실패 결과 반환하면 됩 니다.
      // 신고 완료 후
      // return postResult 호출해야합니다. 그 곳에서 postDetailOption을 nil 처리합니다.
//      switch responseType {
//      case .inaccurateInformation:
//
//      case .personalInformationExposure:
//
//      case .spamOrRepetitiveContent:
//
//      case .vulgarOrAbusiveLanguage:
//
//      case .obsceneContent:
//
//      case .harmfulToMinors:
//
//      case .stopRequest:
//
//      }
      return Just(State.unexpectedError(description: "포스트 신고하기 api가 없습니다."))
        .eraseToAnyPublisher()
      
    }.eraseToAnyPublisher()
  }
  
  func postAuthorBlockHandlerStream() -> Output {
    return postAuthorBlockHandler.flatMap { [weak self] _ in
      guard let self else {
        return Just(State.unexpectedError(description: "앱 내부 에러가 발생됬습니다.")).eraseToAnyPublisher()
      }
      guard let authorId = postDetails?.author.authorId else {
        return Just(State.unexpectedError(
          description: "포스트 저자 id가 없어 차단 api 호출할 수 없습니다")
        ).eraseToAnyPublisher()
      }
      return userBlockUseCase.blockUser(with: authorId)
        .map { [weak self] _ in
          self?.ownerRepository.addBlockedUser(with: authorId)
          return .postReport(.completeUserBlock)
        }
        .catch { error in
          return Just(State.unexpectedError(description: error.localizedDescription)).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension PostDetailViewModel {
  func convertToString(_ travelMainTheme: TravelMainThemeType, subTheme: String) -> String {
    "\(travelMainTheme.rawValue) > \(subTheme)"
  }
  
  func fetchPostDetails(with postId: Int32) {
    postSubscription = postFetchUsecase
      .fetchPost(with: postId).sink { [weak self] completion in
      if case.failure(let error) = completion {
        self?.errorHandler.send(.failedToFetchPostDetails(error))
      }
    } receiveValue: { [weak self] postEntity in
      self?.postDetails = PostMapper.toPostDetails(postEntity, category: postEntity.category)
      self?.postDetailsFetchNotifier.send()
    }
  }
}

// MARK: - PostDetailTableViewDataSource
/// PostDetails가 nil인 경우, numberOfSections을 0으로 반환합니다.
/// postDetails가 nil이 아닌 경우에만 numberOfSections가 3이상으로 반환되고, PostDetailTableViewDataSource의 각 함수들은
/// postDetails not nil 프로퍼티를 바탕으로 데이터를 adapter한테 반환합니다.
extension PostDetailViewModel: PostDetailTableViewDataSource {
  /// 포스트 업로드한 사용자 프로필로 이동히가 위해서 사용됩니다.
  var authorUserId: Int32 {
    return Int32(postDetails?.author.authorId ?? "-1") ?? -1
  }
  
  var title: String {
    return postDetails?.detail.title ?? "데이터가 존재하지 않습니다."
  }
   
  // MARK: - 특정 서브 카테고리에서 여러 개 고를 경우 그중 맨 처음 카테고리 타입만 보여주도록 우선 반환했습니다.
  var cateogry: String {
    guard let postDetails else { return "" }
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
    /// postDetails가 nil인 경우 viewDidLoad시점에 서버로부터 데이터를 가져오기에, postDetails가 nil일 확률은 희박합니다.
    guard let postDetails else {
      return .init(
        userName: "여행자", userThumbnailData: nil,
        travelDuration: "데이터가 존재하지 않습니다.", 
        travelCalendarDateRange: "", uploadedDescription: "")
    }
    let tripDate = postDetails.detail.tripDate
    return .init(
      userName: postDetails.author.nickname,
      userThumbnailData: postDetails.author.profileImageData,
      travelDuration: DateTimeConverter.periodYMD(from: tripDate.startDate, to: tripDate.endDate),
      travelCalendarDateRange: DateTimeConverter.period(from: tripDate.startDate, to: tripDate.endDate),
      uploadedDescription: DateTimeConverter.toString(from: postDetails.detail.createAt))
  }
  
  func postContentItem(at row: Int) -> PostContentEntity {
    return postDetails?.detail.content[row] ?? .text("")
  }
  
  var numberOfSections: Int {
    guard let postDetails else { return 0 }
    return SectionType.defaultNumberOfSections
  }
  
  func numberOfRows(in section: Int) -> Int {
    guard let postDetails else { return 0 }
    let sectionType: PostDetailSection = .init(rawValue: section)
    switch sectionType {
    case .postDescription:
      return 1
    case .postContent:
      return postDetails.detail.content.count
    case .postHeartAndShareArea:
      return 0
    default:
      return PostDetailSection.defaultNumberOfSections
    }
  }
}

// MARK: - ReviewWritingPostReceivable
extension PostDetailViewModel: ReviewWritingPostReceivable {
  func receive(post: Post?) {
    // TODO: - 편집한 리뷰작성 Post를 기반으로 화면을 갱신해야 합니다.
    // 이 아래꺼로 새로 작성된 post를 postDetails로 반영하고 reloadData 해주면 됩니다.
    // self.postDetails = PostMapper.toPostDetails(post, category: category)
    
    // FIXME: - 포스트 편집된거 줄때 카테고리도 편집될수있어서 카테고리까지 같이 줘야 합니다.
    print("DEBUG: PostDetailViewModel에서 편집된 post 객체 받음")
    if post == nil {
      // MARK: - firestore를 통해서 업로드한 것임으로 postId에서 데이터 받아와야합니다.
      // 받아온 후에 아래 로직으로 호출!
      // self.postDetails = PostMapper.toPostDetails(post, category: category)
    } else if let post = post {
      // self.postDetails = PostMapper.toPostDetails(post, category: category)
    }
  }
}
