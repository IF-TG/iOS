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
  private let session: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private let subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(session: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.session = session
    self.backgroundQueue = backgroundQueue
  }
}

extension DefaultDestinationScrapRepository: DestinationScrapRepository {
  // FIXME: - page 및 perPage는 어떤 방식으로 적용할 것인지?
  func getDestinationScrapList(folderName: String) -> AnyPublisher<DestinationScrapList, any Error> {
    let requestDTO = DestinationScrapListRequestDTO(folderName: folderName, page: nil, perPage: nil)
    let endpoint = DestinationScrapEndpoints.getDestinationScrapList(with: requestDTO)
    
    return session.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.toDomain() }
      .eraseToAnyPublisher()
  }
  
  func toggleDestinationScrap(id: Int64, forderName: String) -> AnyPublisher<DestinationScrapToggler, any Error> {
    let requestDTO = DestinationScrapToggleRequestDTO(objectId: id, forderName: forderName)
    let endpoint = DestinationScrapEndpoints.toggleDestinationScrap(with: requestDTO)
    
    return session.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.toDomain() }
      .eraseToAnyPublisher()
  }
  
  func updateDestinationScrap(
    objectIdList: [Int64],
    forderName: String
  ) -> AnyPublisher<[UpdatedDestinationScrap], any Error> {
    let requestDTO = DestinationScrapUpdateRequestDTO(objectIdList: objectIdList, forderName: forderName)
    let endpoint = DestinationScrapEndpoints.updateDestinationScrap(with: requestDTO)
    
    return session.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.map { $0.toDomain() } }
      .eraseToAnyPublisher()
  }
}
