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
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - IntroductionInfoRepository
extension DefaultTourIntroductionInfoRepository: TourIntroductionInfoRepository {
  func fetchShopping(tourContentId: TourContentId) -> AnyPublisher<ShoppingEntity, any Error> {
    let endpoint = TourAPIIntroductionEndpoints.fetchShopping(with: .init(
      contentId: tourContentId.contentId, 
      contentTypeId: tourContentId.contentTypeId
    ))
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tryMap {
        let resultCode = $0.response.header.resultCode
        
        guard resultCode == "0000" else {
          throw TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2))))
        }
        guard let item = $0.response.body.items.item.first else {
          throw TourAPIError.tourAPIProviderInstitutionError(.noDataError)
        }
        
        return item.toDomain()
      }
      .eraseToAnyPublisher()
  }
  
  func fetchFestival(tourContentId: TourContentId)
  -> AnyPublisher<IntroductionInfoFestivalEntity, any Error> {
    
    let endpoint = TourAPIIntroductionEndpoints.fetchFestival(with: .init(
      contentId: tourContentId.contentId,
      contentTypeId: tourContentId.contentTypeId
    ))
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .tryMap {
        let resultCode = $0.response.header.resultCode
        
        guard resultCode == "0000" else {
          throw TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2))))
        }
        guard let item = $0.response.body.items.item.first else {
          throw TourAPIError.tourAPIProviderInstitutionError(.noDataError)
        }
        
        return item.toDomain()
      }
      .eraseToAnyPublisher()
  }
}
