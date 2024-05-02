//
//  DefaultTourCommonInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

final class DefaultTourCommonInfoRepository: TourCommonInfoRepository {
  typealias Endpoint = TourCommonInfoAPIEndpoint
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  func fetchTourCommonInfo(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourCommonInfoEntity], any Error> {
    let requestDTO = TourApiCommonInfoRequestDTO(contentId: contentId, numOfRows: 10, pageNo: 1)
    let endpoint = Endpoint.makeCommonInfoAPIEndpoint(with: requestDTO)
    
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapConnectionError()        .tryMap {
          if $0.response.header.resultCode == "0000" {
            return $0.response.body.items.item.map { $0.toDomain() }
          } else {
            throw TourAPIError(code: $0.response.header.resultCode)
          }
        }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
}
