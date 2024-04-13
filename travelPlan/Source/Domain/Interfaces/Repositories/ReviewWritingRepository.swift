//
//  ReviewWritingRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

protocol ReviewWritingRepository {
  func uploadPost() -> AnyPublisher<Bool, Never>
}
