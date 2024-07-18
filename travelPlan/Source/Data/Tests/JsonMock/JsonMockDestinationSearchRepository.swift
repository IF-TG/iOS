//
//  JsonMockDestinationSearchRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/15/24.
//

import Foundation
import Combine

final class JsonMockDestinationSearchRepository {
   // MARK: - Properties
  private let repository: DestinationSearchRepository
  
  // MARK: - LifeCycle
  init(backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.repository = DefaultDestinationSearchRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: backgroundQueue
    )
  }
}

extension JsonMockDestinationSearchRepository: DestinationSearchRepository {
  func fetchDestinationList(
    by keyword: String,
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[ThumbnailDestination], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationScrap(.getAllByKeyword)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.fetchDestinationList(by: keyword, page: page, perPage: perPage)
  }
}
