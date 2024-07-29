//
//  JsonMockDestinationRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/28/24.
//

import Foundation
import Combine

final class JsonMockDestinationRepository {
  // MARK: - Properties
  private let repository: DestinationRepository
  
  // MARK: - LifeCycle
  init(backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.repository = DefaultDestinationRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: backgroundQueue
    )
  }
}

// MARK: - DestinationRepository
extension JsonMockDestinationRepository: DestinationRepository {
  /// 디버깅 모드일 때 사용합니다. 프로토콜을 따라야 하기 때문에 test 함수와 분리합니다.
  func fetchDestination(
    destinationId: DestinationIdEntity
  ) -> AnyPublisher<DestinationEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .getDestination(.restaurant)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.fetchDestination(destinationId: destinationId)
  }
}

// MARK: - Helpers
extension JsonMockDestinationRepository {
  /// test 시, 모든 contentTypeId에 대해 검증하기 위해 사용합니다.
  func fetchDestination(
    destinationId: DestinationIdEntity,
    mockResponseType: MockResponseType.GetDestination
  ) -> AnyPublisher<DestinationEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData: Data
      
      switch mockResponseType {
      case .festival:
        mockData = MockResponseType
          .getDestination(.festival)
          .mockDataLoader
      case .restaurant:
        mockData = MockResponseType
          .getDestination(.restaurant)
          .mockDataLoader
      case .leports:
        mockData = MockResponseType
          .getDestination(.leports)
          .mockDataLoader
      case .shopping:
        mockData = MockResponseType
          .getDestination(.shopping)
          .mockDataLoader
      case .attraction:
        mockData = MockResponseType
          .getDestination(.attraction)
          .mockDataLoader
      case .cultureFacility:
        mockData = MockResponseType
          .getDestination(.cultureFacility)
          .mockDataLoader
      }

      return (HTTPURLResponse(), mockData)
    }
    
    return repository.fetchDestination(destinationId: destinationId)
  }
}
