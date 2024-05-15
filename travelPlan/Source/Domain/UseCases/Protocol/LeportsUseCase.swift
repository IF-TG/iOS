//
//  LeportsUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation
import Combine

protocol LeportsUseCase {
  func fetchLeportsDetail(tourContentId: TourContentId) -> AnyPublisher<LeportsEntity, any Error>
}
