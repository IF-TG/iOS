//
//  DestinationDetailUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/31/24.
//

import Foundation
import Combine

/// 여행지 상세 화면을 담당합니다.
protocol DestinationDetailUseCase {
  func fetchDetail(destinationId: DestinationIdEntity) -> AnyPublisher<DestinationEntity, any Error>
  func toggleScrap(id: Int, folderName: String?) -> AnyPublisher<DestinationScrapToggler, any Error>
  func toggleLike(id: Int) -> AnyPublisher<DestinationLike, any Error>
}
