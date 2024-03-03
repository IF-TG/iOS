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
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
}

// MARK: - UserInfoRepository
extension DefaultUserInfoRepository: UserInfoRepository {
  func checkIfUserNicknameDuplicate(with name: String) -> Future<Bool, MainError> {
    let reqeustDTO = UserNicknameRequestDTO(nickname: name)
    let endpoint = UserInfoAPIEndpoint.checkIfNicknameDuplicate(with: reqeustDTO)
    return .init { [unowned self] promise in
      service.request(endpoint: endpoint)
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
        }.store(in: &subscriptions)
    }
  }
  
  func updateUserNickname(with name: String) -> Future<Bool, MainError> {
    //TODO: - 로그인 중인 사용자의 userId를 키체인이나 유저디폴츠에서 가져와야 합니다.
    let requestDTO = UserNicknamePatchRequestDTO(nickname: name, userId: 000)
    let endpoint = UserInfoAPIEndpoint.updateUserNickname(with: requestDTO)
    return .init { [unowned self] promise in
      service.request(endpoint: endpoint)
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
        }.store(in: &subscriptions)
    }
  }
}
