//
//  DefaultDestinationScrapRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/11/24.
//

import Foundation
import Combine

final class DefaultDestinationScrapRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension DefaultDestinationScrapRepository: DestinationScrapRepository {
  func getDestinationScrapList(
    folderName: String,
    page: Int32? = nil,
    perPage: Int32? = nil
  ) -> AnyPublisher<[DestinationScrapDetail], any Error> {
    let requestDTO = DestinationScrapListRequestDTO(folderName: folderName, page: page, perPage: perPage)
    let endpoint = DestinationScrapEndpoints.getDestinationScrapList(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.map { $0.toDomain() } }
      .eraseToAnyPublisher()
  }
  
  func toggleDestinationScrap(id: Int64, folderName: String?) -> AnyPublisher<DestinationScrapToggler, any Error> {
    let requestDTO = DestinationScrapToggleRequestDTO(objectId: id, forderName: folderName)
    let endpoint = DestinationScrapEndpoints.toggleDestinationScrap(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.toDomain() }
      .eraseToAnyPublisher()
  }
  
  func updateDestinationScrap(
    objectIdList: [Int64],
    folderName: String
  ) -> AnyPublisher<[UpdatedDestinationScrap], any Error> {
    let requestDTO = DestinationScrapUpdateRequestDTO(objectIdList: objectIdList, folderName: folderName)
    let endpoint = DestinationScrapEndpoints.updateDestinationScrap(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.map { $0.toDomain() } }
      .eraseToAnyPublisher()
  }
}
