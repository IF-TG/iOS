//
//  DefaultAttractionUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation
import Combine

final class DefaultAttractionUseCase {
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

// MARK: - AttractionUseCase
extension DefaultAttractionUseCase: AttractionUseCase {
  func fetchAttractionDetail(tourContentId: TourContentId) -> AnyPublisher<AttractionEntity, any Error> {
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
    
    let attractionPublisher = tourIntroductionInfoRepository.fetchAttratcion(tourContentId: tourContentId)
    
    return Publishers
      .Zip3(commonPublisher, imagePublisher, attractionPublisher)
      .map { (commonEntity, imageDataList, attractionEntity) in
        return AttractionEntity(
          tourContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          restDateString: attractionEntity.restDateString,
          telNumber: attractionEntity.telNumber,
          availableTime: attractionEntity.availableTime,
          canPark: attractionEntity.canPark,
          canAccompanyDog: attractionEntity.canAccompanyDog,
          experienceInfo: attractionEntity.experienceInfo,
          title: commonEntity.title,
          overview: commonEntity.overview,
          address: commonEntity.address.address1,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList
        )
      }
      .eraseToAnyPublisher()
  }
}
