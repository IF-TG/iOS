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
  private let tourDetailCommonInfoRepository: any TourDestinationRepository
  private let tourIntroductionInfoRepository: any TourIntroductionInfoRepository
  // MARK: - LifeCycle
  init(
    tourFestivalInfoRepository: any TourFestivalInfoRepository,
    tourDetailCommonInfoRepository: any TourDestinationRepository,
    tourIntroductionInfoRepository: any TourIntroductionInfoRepository
  ) {
    self.tourFestivalInfoRepository = tourFestivalInfoRepository
    self.tourDetailCommonInfoRepository = tourDetailCommonInfoRepository
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
    let commonPublisher = tourDetailCommonInfoRepository.fetchTourDestinationDetailCommon(
      contentId: contentId,
      numOfRows: nil,
      pageNo: nil
    )
    let introductionPublisher = tourIntroductionInfoRepository.fetchFestival(
      contentId: contentId,
      contentTypeId: 15
    )
    
    return commonPublisher.zip(introductionPublisher)
      .map { (commonEntity, introFestivalEntity) in
        return FestivalEntity(
          ageLimit: introFestivalEntity.ageLimit,
          startDate: introFestivalEntity.startDate,
          endDate: introFestivalEntity.endDate,
          place: introFestivalEntity.place,
          place: commonEntity.overview,
          showTime: introFestivalEntity.showTime,
          fee: introFestivalEntity.fee,
          title: introFestivalEntity.title, //
          image: commonEntity.imageData, //
          tel: commonEntity.contact.telNumber,
          overview: commonEntity.overview
        )
      }
      .eraseToAnyPublisher()
  }
}
