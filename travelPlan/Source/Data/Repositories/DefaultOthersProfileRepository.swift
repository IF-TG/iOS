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
  
  func fetchProfile(with id: Int64) -> Future<ProfileImageEntity, MainError> {
    let requestDTO = UserIdReqeustDTO(userId: id)
    let endpoint = UserInfoAPIEndpoint.fetchProfile(with: requestDTO)
    return Future<ProfileImageEntity, MainError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let entity = responseDTO.result.toDomain()
          promise(.success(entity))
        }.store(in: &subscriptions)
    }
  }
}
