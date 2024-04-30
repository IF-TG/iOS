//
//  DefaultTourDetailCommonRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine

final class DefaultTourDetailCommonRepository: TourDetailCommonRepository {
  typealias Endpoint = TourDetailCommonAPIEndpoint
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  func fetchTourDestinationDetailCommon(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourDestinationDetailCommonEntity], any Error> {
    let requestDTO = TourApiDetailCommonRequestDTO(contentId: contentId, numOfRows: 10, pageNo: 1)
    let endpoint = Endpoint.makeDetailCommonEndpoint(with: requestDTO)
    
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapConnectionError()        
        .tryMap {
          let resultCode = $0.response.header.resultCode
          if resultCode == "0000" {
            return $0.response.body.items.item.map { $0.toDomain() }
          } else {
            throw TourAPIError(
              code: String(resultCode.suffix(2))
            ) ?? .unexpectedErrorFromSuccessfulResponseData("Error code:\(resultCode)")
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
