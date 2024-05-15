//
//  DefaultLeportsUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation
import Combine

final class DefaultLeportsUseCase {
  // MARK: - Dependencies
  private let tourIntroductionInfoRepository: any TourIntroductionInfoRepository
  private let tourCommonInfoRepository: any TourCommonInfoRepository
  private let tourImageRetrieveInfoRepository: any TourImageRetrieveInfoRepository
  
  // MARK: - LifeCycle
  init(tourIntroductionInfoRepository: any TourIntroductionInfoRepository, 
       tourCommonInfoRepository: any TourCommonInfoRepository,
       tourImageRetrieveInfoRepository: any TourImageRetrieveInfoRepository) {
    self.tourIntroductionInfoRepository = tourIntroductionInfoRepository
    self.tourCommonInfoRepository = tourCommonInfoRepository
    self.tourImageRetrieveInfoRepository = tourImageRetrieveInfoRepository
  }
}

// MARK: - LeportsUseCase
extension DefaultLeportsUseCase: LeportsUseCase {
  func fetchLeportsDetail(tourContentId: TourContentId) -> AnyPublisher<LeportsEntity, any Error> {
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
      .map { $0.map { $0.image.original} }
    
    let leportsPublisher = tourIntroductionInfoRepository.fetchLeports(tourContentId: tourContentId)
      
    return Publishers
      .Zip3(commonPublisher, imagePublisher, leportsPublisher)
      .map { (commonEntity, imageDataList, leportsEntity) in
        return LeportsEntity(
          tourContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          operationPeriod: leportsEntity.operationPeriod,
          telNumber: leportsEntity.telNumber,
          restDay: leportsEntity.restDay,
          availableTime: leportsEntity.availableTime,
          canPark: leportsEntity.canPark,
          canAccompanyDog: leportsEntity.canAccompanyDog,
          fee: leportsEntity.fee,
          title: commonEntity.title,
          overview: commonEntity.overview,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList,
          address: commonEntity.address.address1
        )
      }
      .eraseToAnyPublisher()
  }
}
