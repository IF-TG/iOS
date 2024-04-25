//
//  DefaultOthersProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/13/24.
//

import Foundation
import Combine

final class DefaultOthersProfileRepository: UserRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
  
  func fetchProfile(with id: String) -> AnyPublisher<ProfileImageEntity, Error> {
    return Future { [weak self] promise in
      guard let self, let id = Int64(id) else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let requestDTO = UserIdReqeustDTO(userId: id)
      let endpoint = UserInfoAPIEndpoint.fetchProfile(with: requestDTO)
      
      service.request(endpoint: endpoint)
        .mapConnectionError()
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let entity = responseDTO.result.toDomain()
          promise(.success(entity))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
}
