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
  
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  init(service: Sessionable) {
    self.service = service
  }
}

// MARK: - UserInfoRepository
extension DefaultUserInfoRepository: UserInfoRepository {
  func isDuplicatedName(with name: String) -> Future<Bool, Never> {
    let reqeustDTO = UserNicknameRequestDTO(nickname: name)
    let endpoint = UserInfoAPIEndpoint.isDuplicatedNickname(with: reqeustDTO)
    return .init { [weak self] promise in
      self?.subscription = self?.service
        .request(endpoint: endpoint)
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            print("DEBUG: isDuplicatedName(with:) 파싱할때 에러 발생\n  \(error.localizedDescription)")
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.result))
        }
    }
  }
}
