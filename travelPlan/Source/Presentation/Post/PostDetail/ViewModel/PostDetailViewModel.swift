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

final class PostDetailViewModel: PostOptionNotificationBinder {
  typealias SectionType = PostDetailSection

  // MARK: - Dependencies
  private let postFetchUseCase: PostFetchUseCase
  
  private let ownerRepository: LoggedInUserRepository
  
  // private let userBlockUseCase: UserBlockUseCase
  
  // MARK: - Properties
  private var postDetails: PostDetails?
  
  private let postId: Int32
  
  private let actions: PostDetailViewModelActions?
  
  // MARK: - Combine Properties
  private var subscriptions = Set<AnyCancellable>()
  
  private let postDetailsFetchNotifier = PassthroughSubject<Void, Never>()
  
  private let errorHandler = PassthroughSubject<PostDetailViewModelError, Never>()
  
  private let loggedInUserUseCaseHandler = PassthroughSubject<Void, Never>()
  
  private let navigationInfo = PassthroughSubject<Void, Never>()
  
  var postOptionNotificationSubscriptions = Set<AnyCancellable>()
  
  var postHasBlockedNotifier = PassthroughSubject<PostBlockedElement?, Never>()
  
  var userWantToSharePostNotifier = PassthroughSubject<PostShareElement, Never>()
  
  // MARK: - Lifecycle
  init(
    post: Post?,
    postId: Int32,
    postFetchUseCase: PostFetchUseCase,
    ownerRepository: LoggedInUserRepository,
    actions: PostDetailViewModelActions?
  ) {
    if let post = post {
      self.postDetails = PostMapper.toPostDetails(post, category: post.category)
      self.postId = Int32(post.detail.postID) ?? -1
    } else {
      /// postId만 존재한다는 것은 universal link를 통해 공유하기 로직으로 접근된 것입니다.
      self.postId = postId
    }
    self.postFetchUseCase = postFetchUseCase
    self.ownerRepository = ownerRepository
    self.actions = actions
    bind()
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
      loggedInUserUseCaseHandlerStream()
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
}

// MARK: - Private Helpers
private extension PostDetailViewModel {
  func bind() {
    bindPostOptionResult { [weak self] element in
      if let element = element {
        if element.postId == Int32(self?.postDetails?.detail.postID ?? "-1")
            && element.postOptionLocation == .detailPage {
          self?.actions?.showFeedAfterBlockingFeed(element.postId)
        }
      }
    } postShareHandler: { [weak self] element in
      self?.actions?.showPostShare(element)
    }
  }
  
  func convertToString(_ travelMainTheme: TravelMainThemeType, subTheme: String) -> String {
    "\(travelMainTheme.rawValue) > \(subTheme)"
  }
  
  func addCategoryString(_ categoryString: inout String, type: TravelMainThemeType, subTheme: String) {
    let newString = convertToString(type, subTheme: subTheme)
    if categoryString.isEmpty {
      categoryString += newString
    } else {
      categoryString += " , \(newString)"
    }
  }
  
  func fetchPostDetails(with postId: Int32) {
    postFetchUseCase
      .fetchPost(with: postId).sink { [weak self] completion in
      if case.failure(let error) = completion {
        self?.errorHandler.send(.failedToFetchPostDetails(error))
      }
    } receiveValue: { [weak self] postEntity in
      self?.postDetails = PostMapper.toPostDetails(postEntity, category: postEntity.category)
      self?.postDetailsFetchNotifier.send()
    }.store(in: &subscriptions)
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
    
    if let subTheme = themes.first {
      addCategoryString(&categoryString, type: .travelTheme(nil), subTheme: subTheme)
    }
    if let subTheme = partners.first {
      addCategoryString(&categoryString, type: .partner(nil), subTheme: subTheme)
    }
    if let subTheme = seasons.first {
      addCategoryString(&categoryString, type: .season(nil), subTheme: subTheme)
    }
    if let subTheme = regions.first {
      addCategoryString(&categoryString, type: .region(nil), subTheme: subTheme)
    }
    
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
    if postDetails == nil { return 0 }
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
    // MARK: - 편집한 리뷰작성 Post를 기반으로 화면을 갱신해야 합니다.
    // 이 아래꺼로 새로 작성된 post를 postDetails로 반영하고 reloadData 해주면 됩니다.
    // self.postDetails = PostMapper.toPostDetails(post, category: category)
    
    // FIXME: - 포스트 편집된거 줄때 카테고리도 편집될수있어서 카테고리까지 같이 줘야 합니다.
    print("DEBUG: PostDetailViewModel에서 편집된 post 객체 받음")
    if post == nil {
      // MARK: - firestore를 통해서 업로드한 것임으로 postId에서 데이터 받아와야합니다.
      // 받아온 후에 아래 로직으로 호출!
      // self.postDetails = PostMapper.toPostDetails(post, category: category)
    } else if  post != nil {
      // MARK: - 이거 위 분기처리 let post = post 이거로 해야합니다. 지금 switlint준수하려구 이렇게 임시 적으로 했습니다.
      // self.postDetails = PostMapper.toPostDetails(post, category: category)
    }
  }
}
