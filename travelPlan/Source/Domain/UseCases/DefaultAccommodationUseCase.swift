//
//  DefaultAccommodationUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation
import Combine

final class DefaultAccommodationUseCase {
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

// MARK: - AccommodationUseCase
extension DefaultAccommodationUseCase: AccommodationUseCase {
  func fetchAccommodationDetail(tourContentId: TourContentId) -> AnyPublisher<AccommodationEntity, any Error> {
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
    
    let accommodationPublisher = tourIntroductionInfoRepository
      .fetchAccommodation(tourContentId: tourContentId)
    
    return Publishers.Zip3(commonPublisher, imagePublisher, accommodationPublisher)
      .map { (commonEntity, imageDataList, accommodationEntity) in
        return AccommodationEntity(
          tourContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          checkinTime: accommodationEntity.checkinTime,
          checkoutTime: accommodationEntity.checkoutTime,
          roomType: accommodationEntity.roomType,
          canCook: accommodationEntity.canCook,
          internalFacilities: accommodationEntity.internalFacilities,
          telNumber: accommodationEntity.telNumber,
          reservationNumber: accommodationEntity.reservationNumber,
          canPark: accommodationEntity.canCook,
          address: commonEntity.address.address1,
          title: commonEntity.title,
          overview: commonEntity.overview,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList
        )
      }
      .eraseToAnyPublisher()
  }
}
