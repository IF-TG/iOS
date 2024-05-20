//
//  DefaultCourseUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/18/24.
//

import Foundation
import Combine

final class DefaultCourseUseCase {
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

// MARK: - CourseUseCase
extension DefaultCourseUseCase: CourseUseCase {
  func fetchCourseDetail(tourContentId: TourContentId)
  -> AnyPublisher<CourseEntity, any Error> {
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
    
    let coursePublisher = tourIntroductionInfoRepository
      .fetchCourse(tourContentId: tourContentId)
    
    return Publishers
      .Zip3(commonPublisher, imagePublisher, coursePublisher)
      .map { (commonEntity, imageDataList, courseEntity) in
        return CourseEntity(
          tourContentId: TourContentId(contentId: commonEntity.id.contentId,
                                       contentTypeId: commonEntity.id.contentTypeId),
          distance: courseEntity.distance,
          telNumber: courseEntity.telNumber,
          requiredTime: courseEntity.requiredTime,
          title: commonEntity.title,
          address: commonEntity.address.address1,
          overview: commonEntity.overview,
          imageDataList: [commonEntity.image.originalImageData] + imageDataList
        )
      }
      .eraseToAnyPublisher()
  }
}
