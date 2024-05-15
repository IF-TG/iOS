//
//  DefaultCultureFacilityUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation
import Combine

final class DefaultCultureFacilityUseCase {
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

// MARK: - CultureFacilityUseCase
extension DefaultCultureFacilityUseCase: CultureFacilityUseCase {
  func fetchCultureFacility(tourContentId: TourContentId) -> AnyPublisher<CultureFacilityEntity, any Error> {
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
    
    let attractionPublisher = tourIntroductionInfoRepository.fetchCultureFacility(tourContentId: tourContentId)
    
    return Publishers
      .Zip3(commonPublisher, imagePublisher, attractionPublisher)
      .map { (commonEntity, imageDataList, cultureFacilityEntity) in
        return CultureFacilityEntity(
          tourContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          telNumber: cultureFacilityEntity.telNumber,
          availableTime: cultureFacilityEntity.availableTime,
          canPark: cultureFacilityEntity.canPark,
          canAccompanyDog: cultureFacilityEntity.canAccompanyDog,
          restDay: cultureFacilityEntity.restDay,
          address: commonEntity.address.address1,
          title: commonEntity.title,
          overview: commonEntity.overview,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList
        )
      }
      .eraseToAnyPublisher()
  }
}
