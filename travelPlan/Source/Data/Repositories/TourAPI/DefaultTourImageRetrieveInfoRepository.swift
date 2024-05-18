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
  typealias IndexedOriginalImageData = (index: Int, original: Data)
  typealias IndexedOriginalImageDataFetcher = AnyPublisher<IndexedOriginalImageData, any Error>
  
  typealias RetrieveImagesReturnPublisher = AnyPublisher<
    [TourRetrievedImageEntity<TourRetrievedDataImageEntity>], any Error>
  typealias RetrieveOriginalImagesRetrunPublisher = AnyPublisher<
    [TourRetrievedImageEntity<TourRetrievedOriginalImageDataEntity>], any Error>

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
  /// 투어 api에 요청시 제공받는 atomic  json을 받습니다.
  ///
  /// contentId에 따라 해당 컨텐츠의 이미지 정보 json을 numOfRows 만큼 받습니다.
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
  
  /// 투어 api에 요청시 제공받는 이미지 정보와 url 바탕으로 이미지를 데이터로 변환해서 받습니다.
  ///
  /// contentId에 따라 해당 컨텐츠의 이미지 정보와 이미지 원본, 썸네일 데이터를 numOfRows 만큼 받습니다.
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
  
  /// 투어 api에 요청시 제공받는 이미지 정보와 url 바탕으로 이미지를 데이터로 변환해서 받습니다.
  ///
  /// contentId에 따라 해당 컨텐츠의 이미지 정보와 이미지 원본 데이터를 numOfRows 만큼 받습니다.
  func retrieveOriginalImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> RetrieveOriginalImagesRetrunPublisher {
    return retrieveAtomicImages(
      contentId: contentId, numOfRows: numOfRows, pageNo: pageNo)
    .receive(on: backgroundQueue)
    .flatMap { [weak self, backgroundQueue] atomicEntities -> RetrieveOriginalImagesRetrunPublisher in
      guard let self else { return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher() }
      let collectCount = atomicEntities.count
      let indexedOriginalImageDataFetchers: [IndexedOriginalImageDataFetcher] = makeIndexedOriginalImageFetchers(
        from: atomicEntities.map { $0.image },
        backgroundQueue: backgroundQueue)
      
      return Publishers
        .MergeMany(indexedOriginalImageDataFetchers)
        .collect(collectCount)
        .eraseToAnyPublisher()
        .map { indexedOriginalImageDataList in
          let sortedOriginalImageDataList = indexedOriginalImageDataList
            .sorted { $0.index < $1.index }
            .map { $0.original }
          
          return (0..<collectCount).map { index -> TourRetrievedImageEntity<TourRetrievedOriginalImageDataEntity> in
            let atomicEntity = atomicEntities[index]
            let originalImageDataEntity = TourRetrievedOriginalImageDataEntity(
              name: atomicEntity.image.name,
              originalImageData: sortedOriginalImageDataList[index])
            return TourRetrievedImageEntity<TourRetrievedOriginalImageDataEntity>(
              contentId: atomicEntity.contentId,
              image: originalImageDataEntity,
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
    let ImageQueue = DispatchQueue(
      label: "com.yeoga.app.TourImageRetrieveRepository.queue",
      qos: .userInitiated,
      attributes: .concurrent)

    return atomicEntities.enumerated().map { index, atomicEntity in
      return Publishers.Zip(
        imageService.request(imageURL: atomicEntity.originalUrl, queue: ImageQueue)
          .mapError { $0 as Error }
          .eraseToAnyPublisher(),
        imageService.request(imageURL: atomicEntity.thumbnailUrl, queue: ImageQueue)
          .mapError { $0 as Error }
          .eraseToAnyPublisher())
      .map { return (index, ($0, $1)) }
      .eraseToAnyPublisher()
    }
  }
  
  func makeIndexedOriginalImageFetchers(
    from atomicEntities: [TourRetrievedAtomicImageEntity],
    backgroundQueue: DispatchQueue
  ) -> [IndexedOriginalImageDataFetcher] {
    return atomicEntities.enumerated().map { index, atomicEntity -> IndexedOriginalImageDataFetcher in
      return imageService.request(
        imageURL: atomicEntity.originalUrl,
        queue: DispatchQueue(
          label: "com.yeoga.app.TourImageRetrieveRepository.queue",
          qos: .userInitiated,
          attributes: .concurrent))
        .mapError { $0 as Error }
        .map { originalImageData -> IndexedOriginalImageData in
          return (index, originalImageData)
        }.eraseToAnyPublisher()
    }
  }
}
