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
    let imageConverter = ImageConverter()
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .flatMap { [backgroundQueue] in
        let resultCode = $0.response.header.resultCode
        
        guard resultCode == "0000" else {
          return Fail<TourCommonInfoEntity, any Error> (
            error: TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2))))
          )
          .eraseToAnyPublisher()
        }
        
        guard let item = $0.response.body.items.item.first else {
          return Fail<TourCommonInfoEntity, any Error> (
            error: TourAPIError.tourAPIProviderInstitutionError(.noDataError)
          )
          .eraseToAnyPublisher()
        }
        
        let imagePublisher = imageConverter
          .request(imageURL: item.firstimage, queue: backgroundQueue)
          .mapError { $0 as Error }
          .eraseToAnyPublisher()
        let thumbnailPublisher = imageConverter
          .request(imageURL: item.firstimage2, queue: backgroundQueue)
          .mapError { $0 as Error }
          .eraseToAnyPublisher()
        
        return imagePublisher.zip(thumbnailPublisher)
          .map { (imageDate, thumbnailData) in
            return item.toDomain(firstImageData: imageDate, thumbnailImageDate: thumbnailData)
          }.eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
}
