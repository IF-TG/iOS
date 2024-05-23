//
//  PostDetailViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation
import Combine

final class PostDetailViewModel {
  typealias SectionType = PostDetailSection

  // MARK: - Dependencies
  private let postFetchUsecase: PostFetchUseCase
  
  private let ownerRepository: LoggedInUserRepository
  
  private let userBlockUseCase: UserBlockUseCase
  
  // MARK: - Properties
  private var postDetails: PostDetails
  
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
    post: Post,
    category: Post.Category,
    postFetchUsecase: PostFetchUseCase,
    ownerRepository: LoggedInUserRepository,
    userBlockUseCase: UserBlockUseCase,
    actions: PostDetailViewModelActions?
  ) {
    self.postDetails = PostMapper.toPostDetails(post, category: category)
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
  
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    actions?.showAlertForError(description, completion)
  }
  
  func showPostOption() {
    actions?.showPostOption { [weak self] optionState in
      self?.postDetailOption = optionState
      switch optionState {
      case .postBlock:
        guard let authorNickname = self?.postDetails.author.nickname else {
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
    guard let postDetailOption else {
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
  func navigationInfoStream() -> Output {
    return navigationInfo.map { [weak self] _ -> State in
      guard 
        let postTitle = self?.postDetails.detail.title,
        let startDate = self?.postDetails.detail.tripDate.startDate,
        let endDate = self?.postDetails.detail.tripDate.endDate
      else { return .none }
      let tripPeriod = DateTimeConverter.period(from: startDate, to: endDate)
      let postDuration = "\(tripPeriod)의 여정"
      return .viewDidLoad(.naviTitleInfo((postTitle, postDuration)))
    }.eraseToAnyPublisher()
  }
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map { [weak self] _ -> State in
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
        let postAuthorId = self?.postDetails.author.authorId
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
      guard let authorId = postDetails.author.authorId else {
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
}

// MARK: - PostDetailTableViewDataSource
extension PostDetailViewModel: PostDetailTableViewDataSource {
  /// 포스트 업로드한 사용자 프로필로 이동히가 위해서 사용됩니다.
  var authorUserId: Int32 {
    return Int32(postDetails.author.authorId ?? "-1") ?? -1
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
    return .init(
      userName: postDetails.author.nickname,
      userThumbnailData: postDetails.author.profileImageData,
      travelDuration: DateTimeConverter.periodYMD(from: tripDate.startDate, to: tripDate.endDate),
      travelCalendarDateRange: DateTimeConverter.period(from: tripDate.startDate, to: tripDate.endDate),
      uploadedDescription: DateTimeConverter.toString(from: postDetails.detail.createAt))
  }
  
  func postContentItem(at row: Int) -> PostContentEntity {
    return postDetails.detail.content[row]
  }
  
  var numberOfSections: Int {
    return SectionType.defaultNumberOfSections
  }
  
  func numberOfRows(in section: Int) -> Int {
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
