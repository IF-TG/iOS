//
//  DefaultUserInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class DefaultUserInfoRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  
  // MARK: - Properties
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
  
  func updateProfile(with profile: String) -> Future<Bool, MainError> {
    // TODO: - UserDefaults 관리 담당 객체를 통해 로그인 한 사용자의 userID를 가져와야 합니다.
    let userIdReqeustDTO = UserIdReqeustDTO(userId: 13)
    let reqeustDTO = UserProfileRequestDTO(profile: profile)
    let endpoint = UserInfoAPIEndpoint.updateProfile(withQuery: userIdReqeustDTO, body: reqeustDTO)
    return Future<Bool, MainError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let isSucceed = (200...299).contains(Int(responseDTO.status) ?? -1)
          promise(.success(isSucceed))
        }.store(in: &subscriptions)
    }
  }
  
  func saveProfile(with profile: String) -> Future<Bool, MainError> {
    // TODO: - UserDefaults 관리 담당 객체를 통해 로그인 한 사용자의 userID를 가져와야 합니다.
    let userIdRequestDTO = UserIdReqeustDTO(userId: 13)
    let requestDTO = UserProfileRequestDTO(profile: profile)
    let endpoint = UserInfoAPIEndpoint.saveProfile(withQuery: userIdRequestDTO, body: requestDTO)
    return Future<Bool, MainError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let isSucceed = (200...299).contains(Int(responseDTO.status) ?? -1)
          promise(.success(isSucceed))
        }.store(in: &subscriptions)
    }
  }
  
  func deleteProfile() -> Future<Bool, MainError> {
    // TODO: - UserDefaults 관리 담당 객체를 통해 로그인 한 사용자의 userID를 가져와야 합니다.
    let requestDTO = UserIdReqeustDTO(userId: 13)
    let endpoint = UserInfoAPIEndpoint.deleteProfile(with: requestDTO)
    return Future<Bool, MainError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapError { MainError.networkError($0) }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.result))
        }.store(in: &subscriptions)
    }
  }
}
