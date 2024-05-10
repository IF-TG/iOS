//
//  FestivalUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/30/24.
//

import Foundation
import Combine

protocol FestivalUseCase {
  /// 축제 리스트를 가져옵니다.
  func fetchFestivalList() -> AnyPublisher<[FestivalThumbnailEntity], any Error>
  /// 축제 상세 정보를 가져옵니다.
  func fetchFestivalDetail(tourContentId: TourContentId) -> AnyPublisher<FestivalEntity, any Error>
}
