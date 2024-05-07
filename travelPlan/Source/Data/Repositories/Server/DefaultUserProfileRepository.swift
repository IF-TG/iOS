//
//  DefaultUserProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/13/24.
//

import Foundation
import Combine

final class DefaultUserProfileRepository: UserProfileRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
  
  func fetchProfileImageData(with userId: String) -> AnyPublisher<ProfileImageData?, Error> {
    return Future { [weak self] promise in
      guard let self, let id = Int64(userId) else {
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
          guard let imageData = Data(base64Encoded: responseDTO.result.imageURL) else {
            promise(.failure(Swift.DecodingError.dataCorrupted(DecodingError.Context(
              codingPath: [],
              debugDescription: "Failed to convert image to data"))))
            return
          }
          let entity = responseDTO.result.toDomain(with: imageData)
          promise(.success(entity.image))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    fatalError("서버에서 구현되지 않은 api 요청 함수입니다.")
  }
}
