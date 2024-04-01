//
//  MockWrappedUserBlockRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation
import Combine

final class MockWrappedUserBlockRepository: UserBlockRepository {
  // MARK: - Properties
  var subscriptions = Set<AnyCancellable?>()
  let mockService = SessionProvider(session: MockSession.default)
  lazy var repository = DefaultUserBlockRepository(service: mockService)
}

extension MockWrappedUserBlockRepository {
  func blockUser(
    with userId: Int64
  ) -> Future<BlockedUserIdentifyEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.userBlock(.whenUserBlock).mockDataLoader
      return ((.init(), mockData))
    }
    return Future { [weak self] promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
        let subscription = self?.repository.blockUser(with: userId)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { entity in
            promise(.success(entity))
          }
        self?.subscriptions.insert(subscription)
      }      
    }
  }
  
  func fetchBlockedUsers() -> Future<BlockedUserProfileEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.userBlock(.whenBlockedUsersFetch).mockDataLoader
      return ((.init(), mockData))
    }
    return Future { [weak self] promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()) {
        let subscription = self?.repository.fetchBlockedUsers()
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { entity in
            promise(.success(entity))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
}
