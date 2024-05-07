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
  
  // MARK: - LifeCycle
  init(
    tourFestivalInfoRepository: any TourFestivalInfoRepository,
    tourCommonInfoRepository: any TourCommonInfoRepository,
    tourIntroductionInfoRepository: any TourIntroductionInfoRepository
  ) {
    self.tourFestivalInfoRepository = tourFestivalInfoRepository
    self.tourCommonInfoRepository = tourCommonInfoRepository
    self.tourIntroductionInfoRepository = tourIntroductionInfoRepository
  }
}

// MARK: - FestivalUseCase
extension DefaultFestivalUseCase: FestivalUseCase {
  func fetchFestivalList() -> AnyPublisher<[FestivalThumbnailEntity], any Error> {
    return tourFestivalInfoRepository.fetchFestivalList()
      .eraseToAnyPublisher()
  }
  
  func fetchFestivalDetail(contentId: Int) -> AnyPublisher<FestivalEntity, any Error> {
    let commonPublisher = tourCommonInfoRepository.fetchTourCommonInfo(
      contentId: contentId,
      numOfRows: nil,
      pageNo: nil
    )
    let introductionPublisher = tourIntroductionInfoRepository.fetchFestival(
      contentId: contentId,
      contentTypeId: 15
    )
    
    return commonPublisher
      .zip(introductionPublisher)
      .map { (commonEntity, introFestivalEntity) in
        return FestivalEntity(
          ageLimit: introFestivalEntity.ageLimit,
          startDate: introFestivalEntity.startDate,
          endDate: introFestivalEntity.endDate,
          address: commonEntity.address.address1,
          showTime: introFestivalEntity.showTime,
          fee: introFestivalEntity.fee,
          title: commonEntity.title,
          image: commonEntity.image.originalImageData,
          telNumber: commonEntity.contact.telNumber,
          overview: commonEntity.overview
        )
      }
      .eraseToAnyPublisher()
  }
}
