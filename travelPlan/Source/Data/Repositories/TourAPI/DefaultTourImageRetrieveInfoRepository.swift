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
      guard let self = self else { promise(.failure(ReferenceError.invalidReference)); return }
      let group = DispatchGroup()
      group.enter()
      var retrievedImageEntities: [TourRetrievedImageEntity<TourRetrievedAtomicImageEntity>] = []
      let atomicImageRetrieveSubscription = retrieveAtomicImages(
        contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion { promise(.failure(error)) }
        } receiveValue: { entities in
          retrievedImageEntities = entities
          group.leave()
        }
      subscriptions.insert(atomicImageRetrieveSubscription)
      guard wait(forGroup: group, promise: promise) else { return }
      let imageFetchSequence = Publishers.Sequence(sequence: retrievedImageEntities.enumerated())
        .receive(on: backgroundQueue)
        .flatMap { index, entity in
          return Publishers.Zip(
            self.imageFetcher(entity.image.originalUrl),
            self.imageFetcher(entity.image.thumbnailUrl))
          .map { (index, $0) }
          .eraseToAnyPublisher()
        }
        .collect(retrievedImageEntities.count)
        .map { response -> [ImageInfo] in response.sorted(by: { $0.0 < $1.0 }).map { $0.1 } }
        .sink { completion in
          if case .failure(let error) = completion { promise(.failure(error)) }
        } receiveValue: { imageDatas in
          let updatedEntities = imageDatas.enumerated().map { index, imageData in
            let atomicEntity = retrievedImageEntities[index]
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
      subscriptions.insert(imageFetchSequence)
      
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
