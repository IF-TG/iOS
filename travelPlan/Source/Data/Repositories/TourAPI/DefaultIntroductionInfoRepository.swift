//
//  DefaultTourIntroductionInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation
import Combine

final class DefaultTourIntroductionInfoRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - IntroductionInfoRepository
extension DefaultTourIntroductionInfoRepository: TourIntroductionInfoRepository {
  func fetchFestival(
    contentId: Int,
    contentTypeId: Int
  ) -> AnyPublisher<IntroductionInfoFestivalEntity, any Error> {
    let endpoint = TourAPIEndpoints.IntroductionInfo.fetchFestival(with: .init(
      contentId: contentId,
      contentTypeId: contentTypeId
    ))
    
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .tryMap {
          let resultCode = $0.response.header.resultCode
          guard resultCode == "0000" else {
            throw TourAPIError(
              code: String(resultCode.suffix(2))
            ) ?? .unexpectedErrorFromSuccessfulResponseData("Error code:\(resultCode)")
          }
          guard let item = $0.response.body.items.item.first else {
            throw TourAPIError.noItem
          }
          return item.toDomain()
        }
        .sink { completion in
          if case let .failure(error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { entity in
          promise(.success(entity))
        }
      
      self?.subscriptions.insert(subscription)
    }
    .eraseToAnyPublisher()
  }
}
