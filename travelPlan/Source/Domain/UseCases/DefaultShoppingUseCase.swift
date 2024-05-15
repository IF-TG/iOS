//
//  DefaultShoppingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation
import Combine

final class DefaultShoppingUseCase {
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

// MARK: - ShoppingUseCase
extension DefaultShoppingUseCase: ShoppingUseCase {
  func fetchShoppingDetail(tourContentId: TourContentId) -> AnyPublisher<ShoppingEntity, any Error> {
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
    
    let introductionPublisher = tourIntroductionInfoRepository.fetchShopping(
      tourContentId: tourContentId
    )
    
    return Publishers.Zip3(commonPublisher, introductionPublisher, imagePublisher)
      .map { (commonEntity, introductionEntity, imageDataList) in
        return ShoppingEntity(
          tourContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          canPark: introductionEntity.canPark,
          fairDay: introductionEntity.fairDay,
          openTime: introductionEntity.openTime,
          restDay: introductionEntity.restDay,
          saleItem: introductionEntity.saleItem,
          telNumber: introductionEntity.telNumber,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList,
          title: commonEntity.title,
          overview: commonEntity.overview,
          address: commonEntity.address.address1
        )
      }
      .eraseToAnyPublisher()
  }
}
