//
//  ShoppingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation
import Combine

protocol ShoppingUseCase {
  /// 쇼핑 상세 정보를 가져옵니다.
  func fetchShoppingDetail(tourContentId: TourContentId) -> AnyPublisher<ShoppingEntity, any Error>
}
