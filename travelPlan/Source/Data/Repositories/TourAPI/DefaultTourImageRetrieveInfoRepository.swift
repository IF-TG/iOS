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
  typealias ImageInfo = (original: Data, thumbnail: Data)
  
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: Sessionable,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "TourImageRetrieveRepository", qos: .userInitiated, attributes: .concurrent)
  ) {
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
      let atomicImageRetrieveSubscription = self?.retrieveAtomicImages(
        contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion { promise(.failure(error)) }
        } receiveValue: { entities in
          let imageFetchSequence = Publishers.Sequence(sequence: entities.enumerated())
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .flatMap { [weak self] index, entity in
              guard let self else {
                return Fail<(Int, ImageInfo), Error>(error: ReferenceError.invalidReference).eraseToAnyPublisher()
              }
              return Publishers.Zip(
                imageFetcher(entity.image.originalUrl),
                imageFetcher(entity.image.thumbnailUrl))
              .map { (index, $0) }
              .mapError { $0 as Error }
              .eraseToAnyPublisher()
            }
            .collect(entities.count)
            .map { response -> [ImageInfo] in
              let sortedResponse = response.sorted(by: { $0.0 < $1.0 })
              return sortedResponse.map { $0.1 } }
            .sink { completion in
              if case .failure(let error) = completion { promise(.failure(error)) }
            } receiveValue: { imageDatas in
              let updatedEntities = imageDatas.enumerated().map { index, imageData in
                let atomicEntity = entities[index]
                let imageEntity = TourRetrievedDataImageEntity(
                  name: atomicEntity.image.name,
                  original: imageData.original,
                  thumbnail: imageData.thumbnail)
                return TourRetrievedImageEntity<TourRetrievedDataImageEntity>(
                  contentId: atomicEntity.contentId,
                  image: imageEntity,
                  copyright: atomicEntity.copyright)
              }
              promise(.success(updatedEntities))
            }
          self?.subscriptions.insert(imageFetchSequence)
        }
      self?.subscriptions.insert(atomicImageRetrieveSubscription)
    }
    .eraseToAnyPublisher()
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
  
  typealias isGroupSucceed = Bool
  func wait(
    forGroup group: DispatchGroup,
    promise: Future<[TourRetrievedImageEntity<TourRetrievedDataImageEntity>], Error>.Promise
  ) -> isGroupSucceed {
    if group.wait(timeout: .now() + .seconds(7)) == .timedOut {
      let timeoutError = NSError(
        domain: "TourImageRetrieveInfoRepository",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "Operation timed out when tour images retrieve"])
      promise(.failure(timeoutError))
      return false
    }
    return true
  }
}
