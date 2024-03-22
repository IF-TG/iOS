//
//  DefaultPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation
import Combine

final class DefaultPostRepository: PostRepository {
  // MAKR: - Properties
  private let service: Sessionable
  typealias Endpoint = PostAPIEndpoint
  
  private var subscriptions = Set<AnyCancellable?>()
  
  init(service: Sessionable) {
    self.service = service
  }
  
  func fetchPosts(page: Int32, perPage: Int32, category: PostCategory) -> Future<PostsPage, Error> {
    let travelOrder = TravelOrderTypeMapper.toDTO(category.orderBy)
    let travelMainCategory = TravelMainThemeTypeMapper.toMainCategoryDTO(category.mainTheme)
    let travelSubCategory = TravelMainThemeTypeMapper.toSubCategoryDTO(category.mainTheme)
    // TODO: - 유저디폴츠같은 저장소에서 id가져와야 합니다.
    let requestDTO = PostsRequestDTO(
      page: page,
      perPage: perPage,
      orderMethod: travelOrder,
      mainCategory: travelMainCategory,
      subCategory: travelSubCategory,
      userId: 13)
    let endpoint = Endpoint.fetchPosts(with: requestDTO)
    return Future<PostsPage, Error> { [weak self] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postContainers = responseDTO.result.map { $0.toDomain() }
          guard let totalPages = postContainers.first?.totalPosts else {
            // 반드시 필요로한 totalPage가 없는 경우
            promise(.failure(ConnectionError.missingRequiredData))
            return
          }
          let postsPage = PostsPage(
            totalPosts: totalPages,
            posts: postContainers.map { $0.post },
            thumbnails: postContainers.map { $0.thumbnail })
          promise(.success(postsPage))
        }
      self?.subscriptions.insert(subscription)
    }
  }
}
