//
//  ReviewWritingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

protocol ReviewWritingUseCase {
  func uploadPost(content: [PostContentEntity]) -> AnyPublisher<Bool, Never>
}
