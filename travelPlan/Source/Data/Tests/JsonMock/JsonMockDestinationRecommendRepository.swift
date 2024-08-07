//
//  JsonMockDestinationRecommendRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation
import Combine

final class JsonMockDestinationRecommendRepository {
  // MARK: - Properties
  private let repository: DestinationRecommendRepository
  
  // MARK: - LifeCycle
  init(backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.repository = DefaultDestinationRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: backgroundQueue
    )
  }
}

extension JsonMockDestinationRecommendRepository: DestinationRecommendRepository {
  func fetchRecommendationDestinationList(
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[DestinationRecommendSection], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destination(<#T##MockResponseType.Destination#>)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    repository.fetchRecommendationDestinationList(page: page, perPage: perPage)
    
      .map {
        let sections = $0.map {
          $0.destinations
        }
      }
  }
}
