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
  
  func fetchPosts(with page: PostsPage) -> Future<[PostContainer], MainError> {
    let travelOrder = TravelOrderTypeMapper.toDTO(page.category.orderBy)
    let travelMainCategory = TravelMainThemeTypeMapper.toMainCategoryDTO(page.category.mainTheme)
    let travelSubCategory = TravelMainThemeTypeMapper.toSubCategoryDTO(page.category.mainTheme)
    // TODO: - 유저디폴츠같은 저장소에서 id가져와야 합니다.
    let requestDTO = PostsRequestDTO(
      page: Int32(page.page),
      perPage: Int32(page.perPage),
      orderMethod: travelOrder,
      mainCategory: travelMainCategory,
      subCategory: travelSubCategory,
      userId: 13)
    let endpoint = Endpoint.fetchPosts(with: requestDTO)
    return Future { [weak self] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postContainers = responseDTO.result.map { $0.toDomain() }
          promise(.success(postContainers))
        }
      self?.subscriptions.insert(subscription)
    }
  }
  
  func fetchComments(page: Int32, perPage: Int32, postId: Int64) -> Future<PostCommentContainerEntity, any Error> {
    let requestDTO = PostCommentsRequestDTO(page: page, perPage: perPage, postId: postId)
    let endpoint = Endpoint.fetchComments(with: requestDTO)
    return Future { [weak self] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .mapError {
          return $0.asConnectionError }
        .map { $0.result }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { response in
          let mappedResult = PostCommentContainerEntity(
            comments: response.comments.map { $0.toDomain() },
            isFavorited: response.isFavorited)
          promise(.success(mappedResult))
        }
      self?.subscriptions.insert(subscription)
    }
  }
}
