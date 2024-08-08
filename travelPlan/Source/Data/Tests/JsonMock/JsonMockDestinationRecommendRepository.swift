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
    self.repository = DefaultDestinationRecommendRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: backgroundQueue
    )
  }
}

// MARK: - DestinationRecommendRepository
extension JsonMockDestinationRecommendRepository: DestinationRecommendRepository {
  func fetchRecommendationDestinationList(
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[DestinationRecommendSection], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationRecommend(.getDestinationRecommend)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.fetchRecommendationDestinationList(page: page, perPage: perPage)
      .tryMap {
        let sections = try $0.map {
          let destinations = try $0.destinations.map {
            guard let url = Bundle.main.url(forResource: "restaurant_1", withExtension: "png")
            else { throw TransformationError.notExistedUrl }
            
            guard let data = try? Data(contentsOf: url)
            else { throw TransformationError.cannotConvertData }
            
            return DestinationRecommendSection.Destination(
              destinationId: $0.destinationId,
              title: $0.title,
              thumbnailData: data,
              address: $0.address,
              category: $0.category,
              isScaped: $0.isScaped
            )
          }
          return DestinationRecommendSection(
            title: $0.title,
            destinations: destinations
          )
        }
        
        return sections
      }
      .eraseToAnyPublisher()
  }
}
