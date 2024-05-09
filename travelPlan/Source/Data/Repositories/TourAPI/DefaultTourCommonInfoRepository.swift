//
//  DefaultTourCommonInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation
import Combine
import Alamofire

final class DefaultTourCommonInfoRepository: TourCommonInfoRepository {
  typealias Endpoint = TourCommonInfoAPIEndpoint
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Lifecycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
  
  func fetchTourCommonInfo(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<TourCommonInfoEntity, any Error> {
    let requestDTO = TourApiCommonInfoRequestDTO(contentId: contentId, numOfRows: 10, pageNo: 1)
    let endpoint = Endpoint.makeCommonInfoAPIEndpoint(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .flatMap { [weak self, backgroundQueue] in
        let resultCode = $0.response.header.resultCode
        
        guard resultCode == "0000" else {
          return Fail<TourCommonInfoEntity, any Error>(
            error: TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2))))
          )
          .eraseToAnyPublisher()
        }
        
        guard let item = $0.response.body.items.item.first else {
          return Fail<TourCommonInfoEntity, any Error>(
            error: TourAPIError.tourAPIProviderInstitutionError(.noDataError)
          )
          .eraseToAnyPublisher()
        }
        
        guard
          let imagePublisher = self?.makeImageDataPublisher(imageURL: item.firstimage, queue: backgroundQueue),
          let thumbnailPublisher = self?.makeImageDataPublisher(imageURL: item.firstimage2, queue: backgroundQueue)
        else {
          return Fail<TourCommonInfoEntity, any Error>(error: ReferenceError.invalidReference)
            .eraseToAnyPublisher()
        }
        
        return imagePublisher.zip(thumbnailPublisher)
          .map { (imageData, thumbnailData) in 
            return item.toDomain(firstImageData: imageData, thumbnailImageDate: thumbnailData)
          }.eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
extension DefaultTourCommonInfoRepository {
  private func makeImageDataPublisher(imageURL: String, queue: DispatchQueue) -> AnyPublisher<Data, any Error> {
    let imageDataFetcher = ImageDataFetcher()
    
    return imageDataFetcher
      .request(imageURL: imageURL, queue: queue)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
