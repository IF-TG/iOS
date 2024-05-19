//
//  TourImageRetrieveInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation
import Combine

protocol TourImageRetrieveInfoRepository {
  /// 서버에서 이미지 url을 받아옵니다.
  func retrieveAtomicImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedAtomicImageEntity>], Error>
  
  /// 서버에서 제공한 이미지 url을 Data로 가공해서 원본, 섬네일 이미지들을 받아옵니다.
  func retrieveImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedDataImageEntity>], Error>
  
  /// 서버에서 제공한 이미지 url을 Data로 가공해서 원본 이미지들을  받아옵니다.
  func retrieveOriginalImages(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) -> AnyPublisher<[TourRetrievedImageEntity<TourRetrievedOriginalImageDataEntity>], any Error>
}
