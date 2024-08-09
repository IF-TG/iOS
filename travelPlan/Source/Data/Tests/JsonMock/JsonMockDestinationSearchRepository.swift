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
        .destination(.getAllByKeyword)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.fetchDestinationList(by: keyword, page: page, perPage: perPage)
      .tryMap {
        guard let url = Bundle.main.url(forResource: "restaurant_1", withExtension: "png")
        else { throw TransformationError.notExistedUrl }

        guard let data = try? Data(contentsOf: url)
        else { throw TransformationError.cannotConvertData }
        
        return $0.map {
          
          ThumbnailDestination(
            id: $0.id,
            title: $0.title,
            thumbnailImageData: data,
            address: $0.address,
            category: $0.category,
            isScraped: $0.isScraped
          )
        }
      }
      .eraseToAnyPublisher()
  }
}
