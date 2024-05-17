//
//  CourseUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 5/18/24.
//

import Foundation
import Combine

protocol CourseUseCase {
  func fetchCourseDetail(tourContentId: TourContentId) -> AnyPublisher<CourseEntity, any Error>
}
