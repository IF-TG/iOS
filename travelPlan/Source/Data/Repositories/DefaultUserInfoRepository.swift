//
//  DefaultUserInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class DefaultUserInfoRepository {
  // MARK: - Properties
  private let service: Sessionable
  
  private var subscription = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
}

// MARK: - UserInfoRepository
extension DefaultUserInfoRepository: UserInfoRepository {
  func isDuplicatedName(with name: String) -> Future<Bool, MainError> {
    let reqeustDTO = UserNicknameRequestDTO(nickname: name)
    let endpoint = UserInfoAPIEndpoint.isDuplicatedNickname(with: reqeustDTO)
    return .init { [weak self] promise in
      guard var subscription = self?.subscription else {
        promise(.failure(.referenceError(.weakSelfError)))
        return
      }
      self?.service.request(endpoint: endpoint)
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            promise(.failure(.networkError(error)))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.result))
        }.store(in: &subscription)
    }
  }
  
  func updateUserNickname(with name: String) -> Future<Bool, MainError> {
    //TODO: - 로그인 중인 사용자의 userId를 키체인이나 유저디폴츠에서 가져와야 합니다.
    let requestDTO = UserNicknamePatchRequestDTO(nickname: name, userId: 000)
    let endpoint = UserInfoAPIEndpoint.updateUserNickname(with: requestDTO)
    return .init { [weak self] promise in
      guard var subscription = self?.subscription else {
        promise(.failure(.referenceError(.weakSelfError)))
        return
      }
      self?.service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.result))
        }.store(in: &subscription)
    }
  }
}
