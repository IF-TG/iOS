//
//  DestinationLikeRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/24/24.
//

import Foundation
import Combine

protocol DestinationLikeRepository {
  /// 여행지 좋아요 추가/삭제를 요청합니다.
  func toggleDestinationLike(destinationId: Int) -> AnyPublisher<Void, Never>
}
