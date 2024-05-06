//
//  TourImagesRetrieveInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation
import Combine

protocol TourImagesRetrieveInfoRepository {
  /// 서버에서 이미지 url을 받아옵니다.
  func retrieveImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedAtomicImageEntity>], Error>
  
  /// 서버에서 이미지 url을 Data로 가공해서 받아옵니다.
  func retrieveImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedDataImageEntity>], Error>
}
