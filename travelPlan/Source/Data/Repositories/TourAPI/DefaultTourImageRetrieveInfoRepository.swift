//
//  DefaultTourRetrieveInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation
import Combine
import Alamofire

final class DefaultTourImageRetrieveInfoRepository {
  typealias Endpoint = TourImageInfoAPIEndpoint
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: Sessionable,
    backgroundQueue: DispatchQueue = DispatchQueue(label: "TourImageRetrieveRepository")) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - TourImagesRetrieveInfoRepository
extension DefaultTourImageRetrieveInfoRepository: TourImageRetrieveInfoRepository {
  func retrieveAtomicImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedAtomicImageEntity>], any Error> {
    let request = TourApiImageRetrieveRequestDTO(contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
    let endpoint = Endpoint.makeImageInfoRetrieveEndpoint(with: request)
    return service
      .request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .receive(on: backgroundQueue)
      .tryFilter { responseDTO in
        let resultCode = responseDTO.response.header.resultCode
        guard resultCode == "0000" else {
          throw TourAPIError(code: String(resultCode.suffix(2))) ?? TourAPIError
            .unexpectedErrorFromSuccessfulResponseData(resultCode)
        }
        return !responseDTO.response.body.items.item.isEmpty
      }.map { $0.response.body.items.item.map { $0.toDomain()} }
      .eraseToAnyPublisher()
  }
  
  func retrieveImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedDataImageEntity>], any Error> {
    return Future { [weak self, backgroundQueue] promise in
      self?.retrieveAtomicImages(contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink(receiveCompletion: { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        }, receiveValue: { entities in
          entities.enumerated().forEach {
            $0.element.image.originalUrl
            
          }
        })
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
fileprivate extension DefaultTourImageRetrieveInfoRepository {
  func imageFetcher(_ url: String) -> Future<Data, AFError> {
    return Future { promise in
      AF.request(url)
        .responseData { response in
          promise(response.result)
        }
    }
  }
}
