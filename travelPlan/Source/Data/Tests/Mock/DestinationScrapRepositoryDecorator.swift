//
//  DestinationScrapRepositoryDecorator.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation
import Combine

final class DestinationScrapRepositoryDecorator {
  // MARK: - Properties
  private let repository: DestinationScrapRepository
  
  // MARK: - LifeCycle
  init(backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.repository = DefaultDestinationScrapRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: backgroundQueue
    )
  }
}

// MARK: - DestinationScrapRepository
extension DestinationScrapRepositoryDecorator: DestinationScrapRepository {
  func getDestinationScrapList(
    folderName: String
  ) -> AnyPublisher<[DestinationScrapDetail], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationScrap(.getAllDestinationScrapsByScrapFolderAndUserId)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.getDestinationScrapList(folderName: folderName)
  }
  
  func toggleDestinationScrap(
    id: Int64,
    folderName: String
  ) -> AnyPublisher<DestinationScrapToggler, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationScrap(.toggleDestinationScrap)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.toggleDestinationScrap(id: id, folderName: folderName)
  }
  
  func updateDestinationScrap(
    objectIdList: [Int64],
    folderName: String
  ) -> AnyPublisher<[UpdatedDestinationScrap], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationScrap(.updateDestinationScrap)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.updateDestinationScrap(objectIdList: objectIdList, folderName: folderName)
  }
}
