//
//  JsonMockDestinationScrapRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation
import Combine

final class JsonMockDestinationScrapRepository {
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
extension JsonMockDestinationScrapRepository: DestinationScrapRepository {
  func getDestinationScrapList(	
    folderName: String,
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[DestinationScrapDetail], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationScrap(.getAllDestinationScrapsByScrapFolderAndUserId)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.getDestinationScrapList(folderName: folderName, page: page, perPage: perPage)
  }
  
  func toggleDestinationScrap(
    id: Int,
    folderName: String?
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
    objectIdList: [Int],
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
