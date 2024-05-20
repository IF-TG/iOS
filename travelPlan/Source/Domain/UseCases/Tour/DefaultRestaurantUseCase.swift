//
//  DefaultRestaurantUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation
import Combine

final class DefaultRestaurantUseCase {
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

// MARK: - RestaurantUseCase
extension DefaultRestaurantUseCase: RestaurantUseCase {
  func fetchRestaurantDetail(tourContentId: TourContentId) -> AnyPublisher<RestaurantEntity, any Error> {
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
    
    let restaurantPublisher = tourIntroductionInfoRepository.fetchRestaurant(tourContentId: tourContentId)
    
    return Publishers
      .Zip3(commonPublisher, imagePublisher, restaurantPublisher)
      .map { (commonEntity, imageDataList, restaurantEntity) in
        return RestaurantEntity(
          toutContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          signatureDish: restaurantEntity.signatureDish,
          menu: restaurantEntity.menu,
          telNumber: restaurantEntity.telNumber,
          canPark: restaurantEntity.canPark,
          businessHour: restaurantEntity.businessHour,
          restDay: restaurantEntity.restDay,
          title: commonEntity.title,
          address: commonEntity.address.address1,
          overview: commonEntity.overview,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList
        )
      }
      .eraseToAnyPublisher()
  }
}
