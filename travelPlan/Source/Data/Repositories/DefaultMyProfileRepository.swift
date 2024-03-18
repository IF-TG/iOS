//
//  DefaultMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine
import Foundation

// MARK: - Publisher extension
private extension Publisher {
  func mapMyProfileRepositoryError<E>(
    _ transform: @escaping (Self.Failure) -> E
  ) -> Publishers.MapError<Self, MyProfileRepositoryError> {
    return self.mapError { error -> MyProfileRepositoryError in
      if let connectionError = error.asAFError?.mapConnectionError {
        return MyProfileRepositoryError.networkError(connectionError)
      }
      return MyProfileRepositoryError.unknown(description: error.localizedDescription)
    }
  }
}

final class DefaultMyProfileRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private lazy var othersProfileRepository = DefaultOthersProfileRepository(service: service)
  private typealias MyInfoManager = UserDefaultsManager.User
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
}

// MARK: - MyProfileRepository
extension DefaultMyProfileRepository: MyProfileRepository {
  var isProfileSavedInServer: Bool {
    MyInfoManager.isSavedProfileInServer
  }
  
  func checkIfUserNicknameDuplicate(with name: String) -> Future<Bool, MyProfileRepositoryError> {
    let reqeustDTO = UserNicknameRequestDTO(nickname: name)
    let endpoint = UserInfoAPIEndpoint.checkIfNicknameDuplicate(with: reqeustDTO)
    return .init { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapError({ error in
          if let connectionError = error.mapConnectionError {
            return MyProfileRepositoryError.networkError(connectionError)
          }
          return MyProfileRepositoryError.unknown(description: error.localizedDescription)
        })
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
  
  func updateUserNickname(with name: String) -> Future<Bool, MyProfileRepositoryError> {
    guard let loggedInUserId = MyInfoManager.id else {
      return Future { promise in
        promise(.failure(.invaildUserId))
      }
    }
    
    let requestDTO = UserNicknamePatchRequestDTO(nickname: name, userId: loggedInUserId)
    let endpoint = UserInfoAPIEndpoint.updateUserNickname(with: requestDTO)
    return .init { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapMyProfileRepositoryError { $0 }
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          if responseDTO.result {
            MyInfoManager.updateNickname(with: name)
          }
          promise(.success(responseDTO.result))
        }.store(in: &subscriptions)
    }
  }
  
  /// 업데이트는 서버 로직에서 삭제 -> 저장을 한번에 하는 기능입니다.
  func updateProfile(with profile: String) -> Future<Bool, MyProfileRepositoryError> {
    guard let loggedInUserId = MyInfoManager.id else {
      return Future { promise in
        promise(.failure(.invaildUserId))
      }
    }
    
    let userIdReqeustDTO = UserIdReqeustDTO(userId: loggedInUserId)
    let reqeustDTO = UserProfileRequestDTO(profile: profile)
    let endpoint = UserInfoAPIEndpoint.updateProfile(withQuery: userIdReqeustDTO, body: reqeustDTO)
    return Future<Bool, MyProfileRepositoryError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapMyProfileRepositoryError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          let isSucceed = (200...299).contains(Int(responseDTO.status) ?? -1)
          MyInfoManager.updateProfileURL(with: responseDTO.result.imageURL)
          promise(.success(isSucceed))
        }.store(in: &subscriptions)
    }
  }
  
  func saveProfile(with profile: String) -> Future<Bool, MyProfileRepositoryError> {
    guard let loggedInUserId = MyInfoManager.id else {
      return Future { promise in
        promise(.failure(.invaildUserId))
      }
    }
    
    let userIdRequestDTO = UserIdReqeustDTO(userId: loggedInUserId)
    let requestDTO = UserProfileRequestDTO(profile: profile)
    let endpoint = UserInfoAPIEndpoint.saveProfile(withQuery: userIdRequestDTO, body: requestDTO)
    return Future<Bool, MyProfileRepositoryError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapMyProfileRepositoryError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          MyInfoManager.updateProfileURL(with: profile)
          let isSucceed = (200...299).contains(Int(responseDTO.status) ?? -1)
          promise(.success(isSucceed))
        }.store(in: &subscriptions)
    }
  }
  
  func deleteProfile() -> Future<Bool, MyProfileRepositoryError> {
    guard let loggedInUserId = MyInfoManager.id else {
      return Future { promise in
        promise(.failure(.invaildUserId))
      }
    }
    
    let requestDTO = UserIdReqeustDTO(userId: loggedInUserId)
    let endpoint = UserInfoAPIEndpoint.deleteProfile(with: requestDTO)
    return Future<Bool, MyProfileRepositoryError> { [unowned self] promise in
      service.request(endpoint: endpoint)
        .mapMyProfileRepositoryError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          MyInfoManager.deleteProfile()
          promise(.success(responseDTO.result))
        }.store(in: &subscriptions)
    }
  }
  
  func fetchProfile() -> Future<ProfileImageEntity, MyProfileRepositoryError> {
    // UserDefaults 확인
    if let imageURL = MyInfoManager.userProfileURL {
      return Future { promise in
        promise(.success(.init(image: imageURL)))
      }
    }
    
    guard let loggedInUserId = MyInfoManager.id else {
      return Future { promise in
        promise(.failure(.invaildUserId))
      }
    }
    
    // 프로필 없는 경우 서버에서 불러오기
    return Future { [unowned self] promise in
      othersProfileRepository.fetchProfile(with: loggedInUserId)
        .mapMyProfileRepositoryError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { profileImageEntity in
          MyInfoManager.updateProfileURL(with: profileImageEntity.image)
          promise(.success(profileImageEntity))
        }.store(in: &subscriptions)
    }
  }
}
