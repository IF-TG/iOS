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
  typealias IndexedImageInfo = (index: Int, imageInfo: ImageInfo)
  typealias IndexedImageInfoFetcher = AnyPublisher<IndexedImageInfo, any Error>
  typealias RetrieveImagesReturnPublisher = AnyPublisher<
    [TourRetrievedImageEntity<TourRetrievedDataImageEntity>], any Error>

  // MARK: - Dependencies
  private let service: Sessionable
  private let imageService: ImageSessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: Sessionable,
    imageService: ImageSessionable,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "TourImageRetrieveRepository", qos: .userInitiated, attributes: .concurrent)
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
    self.imageService = imageService
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
          throw TourAPIError.publicDataPortalError(.init(code: String(resultCode.suffix(2))))
        }
        return !responseDTO.response.body.items.item.isEmpty
      }.map { $0.response.body.items.item.map { $0.toDomain()} }
      .eraseToAnyPublisher()
  }
  
  func retrieveImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> RetrieveImagesReturnPublisher {
    return retrieveAtomicImages(
        contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
        .receive(on: backgroundQueue)
        .flatMap { [weak self, backgroundQueue] atomicEntities -> RetrieveImagesReturnPublisher in
          guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
          let collectCount = atomicEntities.count
          let indexedImageInfoFetchers = makeIndexedImageInfoFetchers(
            from: atomicEntities.map { $0.image },
            backgroundQueue: backgroundQueue)
          
          return Publishers
            .MergeMany(indexedImageInfoFetchers)
            .collect(collectCount)
            .eraseToAnyPublisher()
            .map { indexedImageInfoList in
              let sortedImageInfoList: [ImageInfo] = indexedImageInfoList
                .sorted { $0.index < $1.index }
                .map { ($0.imageInfo.original, $0.imageInfo.thumbnail) }
              return (0..<collectCount).map { index -> TourRetrievedImageEntity<TourRetrievedDataImageEntity> in
                let atomicEntity = atomicEntities[index]
                let imageDataEntity = TourRetrievedDataImageEntity(
                  name: atomicEntity.image.name,
                  original: sortedImageInfoList[index].original,
                  thumbnail: sortedImageInfoList[index].thumbnail)
                return TourRetrievedImageEntity<TourRetrievedDataImageEntity>(
                  contentId: atomicEntity.contentId,
                  image: imageDataEntity,
                  copyright: atomicEntity.copyright)
              }
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
fileprivate extension DefaultTourImageRetrieveInfoRepository {
  func makeIndexedImageInfoFetchers(
    from atomicEntities: [TourRetrievedAtomicImageEntity],
    backgroundQueue: DispatchQueue
  ) -> [IndexedImageInfoFetcher] {
    return atomicEntities.enumerated().map { index, atomicEntity in
      return Publishers.Zip(
        imageService.request(imageURL: atomicEntity.originalUrl, queue: backgroundQueue)
          .mapError { $0 as Error }
          .eraseToAnyPublisher(),
        imageService.request(imageURL: atomicEntity.thumbnailUrl, queue: backgroundQueue)
          .mapError { $0 as Error }
          .eraseToAnyPublisher())
      .map { return (index, ($0, $1)) }
      .eraseToAnyPublisher()
    }
  }
}
