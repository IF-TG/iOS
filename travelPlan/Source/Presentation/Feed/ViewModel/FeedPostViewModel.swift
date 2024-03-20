//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

class FeedPostViewModel: PostViewModel {
  // MARK: - Properties
  var currentPage: Int32 = 1
  
  var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  let perPage: Int32 = 10
  
  var posts: [PostInfo] = []
  
  var postDetailedThumbnails: [[String]] = []
  
  var isPaging: Bool = false
  
  // TODO: - 서버한테 totalPostsCount나 totalPage 추가해야한다고해야합니다. 어느 페이지가 끝인지 알수없어서 무한 요청 갈수도 있음.
  var totalPostsCount: Int32 = 3
  
  var hasMorePages: Bool {
    let totalPageCount = totalPostsCount/perPage
    return currentPage < totalPageCount
  }
  
  private let category: PostCategory
  
  private let postUseCase: PostUseCase
  
  // MARK: - Lifecycle
  init(postCategory: PostCategory, postUseCase: PostUseCase) {
    self.postUseCase = postUseCase
    self.category = postCategory
  }
}

// MARK: - FeedPostViewModelable
extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      nextPageStream(input),
      feedRefreshStream(input)]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FeedPostViewModel {
  func nextPageStream(_ input: Input) -> Output {
    return input.nextPage
      .flatMap { [weak self] _ in
        return self?.fetchPosts()
          .map { [weak self] postContainers -> State in
            self?.appendPosts(postContainers)
            return .nextPage
          }.catch { error in
            // TODO: - 에러는 어떻게 처리할까? 경우를 따져보자. 레포, 유즈케이스 에러.... .. 레포가 다른데서도 사용된다면? 어느에러를 던져야지?
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func feedRefreshStream(_ input: Input) -> Output {
    return input.nextPage
      .flatMap { [weak self] in
        self?.removeAllPage()
        return self?.fetchPosts()
          .map { postContainers -> State in
            self?.appendPosts(postContainers)
            return .refresh
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 중 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func appendPosts(_ postContainers: [PostContainer]) {
    let loadedPosts = postContainers.map { postContainer in
      return PostMapper.toPostInfo(postContainer.post, thumbnails: postContainer.thumbnails)
    }
    posts.append(contentsOf: loadedPosts)
  }
  
  func removeAllPage() {
    currentPage = 1
    posts.removeAll()
    postDetailedThumbnails.removeAll()
  }
}

// MARK: - PostDataSource
extension FeedPostViewModel {
  // 이를 호출할때 hasMorePages가 false라면 에러 던지자. 더이상 페이지 없다고
  func fetchPosts() -> AnyPublisher<[PostContainer], any Error> {
    let category = PostCategory(
      mainTheme: category.mainTheme,
      orderBy: category.orderBy)
    let postFetchRequestValue = PostFetchRequestValue(
      page: nextPage,
      perPage: perPage,
      category: category)
    return postUseCase.fetchPosts(with: postFetchRequestValue)
      .map { [weak self] postContainers in
        postContainers.forEach { postContainer in
          self?.postDetailedThumbnails.append(postContainer.post.detail.postImages.map { $0.imageUri })
        }
        self?.currentPage += 1
        self?.isPaging = false
        return postContainers
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - FeedPostViewAdapterDataSource
extension FeedPostViewModel: FeedPostViewAdapterDataSource {
  var headerItem: PostFilterOptions {
    return .travelMainTheme(category.mainTheme)
  }
  
  var numberOfItems: Int {
    posts.count
  }
  
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    return PostThumbnailCountValue(postItem(at: index).content.thumbnailURLs.count)
  }
  
  func postItem(at index: Int) -> PostInfo {
    return posts[index]
  }
}
