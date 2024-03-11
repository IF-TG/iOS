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
  
  private var subscriptions = Set<AnyCancellable>()
  
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
    return .init { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let postContainers = responseDTO.result.map { $0.toDomain() }
          promise(.success(postContainers))
        }.store(in: &subscriptions)
    }
  }
}
