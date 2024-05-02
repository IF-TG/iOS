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
    // TODO: - 공통정보조회, 소개정보조회를 사용해서 FestivalEntity를 반환해야합니다.
    let commonPublisher = tourDetailCommonInfoRepository.fetchTourDestinationDetailCommon(
      contentId: contentId,
      numOfRows: nil,
      pageNo: nil
    )
    .eraseToAnyPublisher()
    
    let introductionPublisher = tourIntroductionInfoRepository.fetchFestival(
      contentId: contentId,
      contentTypeId: 15
    )
      .eraseToAnyPublisher()
    
    
  }
}
