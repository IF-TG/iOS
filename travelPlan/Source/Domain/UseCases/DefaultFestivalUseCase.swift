//
//  DefaultFestivalUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/30/24.
//

import Foundation
import Combine

final class DefaultFestivalUseCase {
  // MARK: - Dependencies
  private let tourFestivalInfoRepository: any TourFestivalInfoRepository
  private let tourCommonInfoRepository: any TourCommonInfoRepository
  private let tourIntroductionInfoRepository: any TourIntroductionInfoRepository
  private let tourImageRetrieveInfoRepository: any TourImageRetrieveInfoRepository

  // MARK: - LifeCycle
  init(
    tourFestivalInfoRepository: any TourFestivalInfoRepository,
    tourCommonInfoRepository: any TourCommonInfoRepository,
    tourIntroductionInfoRepository: any TourIntroductionInfoRepository,
    tourImageRetrieveInfoRepository: any TourImageRetrieveInfoRepository
  ) {
    self.tourFestivalInfoRepository = tourFestivalInfoRepository
    self.tourCommonInfoRepository = tourCommonInfoRepository
    self.tourIntroductionInfoRepository = tourIntroductionInfoRepository
    self.tourImageRetrieveInfoRepository = tourImageRetrieveInfoRepository
  }
}

// MARK: - FestivalUseCase
extension DefaultFestivalUseCase: FestivalUseCase {
  func fetchFestivalList() -> AnyPublisher<[FestivalThumbnailEntity], any Error> {
    return tourFestivalInfoRepository.fetchFestivalList()
      .eraseToAnyPublisher()
  }
  
  func fetchFestivalDetail(tourContentId: TourContentId) -> AnyPublisher<FestivalEntity, any Error> {
    let commonPublisher = tourCommonInfoRepository.fetchTourCommonInfo(
      contentId: tourContentId.contentId,
      numOfRows: nil,
      pageNo: nil
    )
    
    let imagePublisher = tourImageRetrieveInfoRepository.retrieveImages(
      contentId: tourContentId.contentId,
      numOfRows: nil,
      pageNo: nil
    )
      .map { $0.map { $0.image.original } }
    
    let introductionPublisher = tourIntroductionInfoRepository.fetchFestival(
      tourContentId: tourContentId
    )
    
    return Publishers
      .Zip3(commonPublisher, introductionPublisher, imagePublisher)
      .map { (commonEntity, introFestivalEntity, imageDataList) in
        return FestivalEntity(
          tourContentId: .init(contentId: commonEntity.id.contentId,
                               contentTypeId: commonEntity.id.contentTypeId),
          ageLimit: introFestivalEntity.ageLimit,
          startDate: introFestivalEntity.startDate,
          endDate: introFestivalEntity.endDate,
          address: commonEntity.address.address1,
          showTime: introFestivalEntity.showTime,
          fee: introFestivalEntity.fee,
          title: commonEntity.title,
          images: [commonEntity.image.originalImageData] + imageDataList,
          telNumber: commonEntity.contact.telNumber,
          overview: commonEntity.overview
        )
      }
      .eraseToAnyPublisher()
  }
}
