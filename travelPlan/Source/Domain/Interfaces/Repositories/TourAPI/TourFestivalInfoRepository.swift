//
//  TourFestivalInfoRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/30/24.
//
 
import Foundation
import Combine

/// [행사정보조회]
///
/// 행사 / 공연 / 축제 정보를 날짜로 조회하는 기능입니다.
///
/// contentType이 행사 / 공연 / 축제 인 경우만 유효합니다.
///
/// 파라미터에 따라 제목순, 수정일(최신순), 등록일순 정렬 검색을 제공합니다.
protocol TourFestivalInfoRepository {
  func fetchFestivalList() -> AnyPublisher<[FestivalThumbnailEntity], any Error>
}
