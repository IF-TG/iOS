//
//  PostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Alamofire
import Combine
import Foundation

protocol PostUseCase {
  func fetchPosts() -> Future<[PostEntity], AFError>
}

// FIXME: - 임시적으로 추가했습니다.
struct PostEntity {
  let id: Int
  let profileImageURL: String
  let title: String
  let userName: String
  let duration: String
  let yearMonthDayRange: String
  let thumbnailImageURls: [String]
  let contentText: String
  let heartCount: Int
  let commentCount: Int
  let isSelectedHeart: Bool = false
}

class PostViewModel {
  // MARK: - Properties
  @Published private(set) var posts: [PostInfo] = []
  
  private let defaultUseCase: PostUseCase
  
  private var subscriptions = Set<AnyCancellable>()
  
  init(postUseCase: PostUseCase) {
    defaultUseCase = postUseCase
    
    bindData()
  }
}

// MARK: - Public helpers
extension PostViewModel {
  func updatePost(_ index: Int, post: PostInfo) {
    posts[index] = post
  }
}

// MARK: - Private Helpers
private extension PostViewModel {
  func bindData() {
    defaultUseCase.fetchPosts()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        self?.handleFetchedPostError(from: completion)
      }, receiveValue: { [weak self] postEntities in
        self?.posts = postEntities.map {
          let headerContentBottomInfo = PostHeaderContentBottomInfo(
            userName: $0.userName,
            duration: $0.duration,
            yearMonthDayRange: $0.yearMonthDayRange)
          let headerContentInfo = PostHeaderContentInfo(title: $0.title, bottomViewInfo: headerContentBottomInfo)
          let headerInfo = PostHeaderInfo(imageURL: $0.profileImageURL, contentInfo: headerContentInfo)
          let contentInfo = PostContentInfo(text: $0.contentText, thumbnailURLs: $0.thumbnailImageURls)
          let footerInfo = PostFooterInfo(
            heartCount: "\($0.heartCount)",
            heartState: $0.isSelectedHeart,
            commentCount: "\($0.commentCount)")
          
          return PostInfo(postId: $0.id, header: headerInfo, content: contentInfo, footer: footerInfo)
        }
      }).store(in: &subscriptions)
  }
  
  func handleFetchedPostError(from completion: Subscribers.Completion<AFError>) {
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print("에러처리해야함.", error.localizedDescription)
    }
  }
}

// MARK: - PostViewAdapterDataSource
extension PostViewModel: PostViewAdapterDataSource {
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    return PostThumbnailCountValue(postItem(at: index).content.thumbnailURLs.count)
  }
  
  var numberOfItems: Int {
    posts.count
  }
  
  func postItem(at index: Int) -> PostInfo {
    return posts[index]
  }
}
