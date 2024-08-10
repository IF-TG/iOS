//
//  DefaultDestinationRecommendUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 8/11/24.
//

import Foundation
import Combine

final class DefaultDestinationRecommendUseCase {
  // MARK: - Dependencies
  private let recommendRepository: any DestinationRecommendRepository
  private let scrapRepository: any DestinationScrapRepository
  // MARK: - Properties
  
  // MARK: - LifeCycle
  init(
    recommendRepository: any DestinationRecommendRepository,
    scrapRepository: any DestinationScrapRepository
  ) {
    self.recommendRepository = recommendRepository
    self.scrapRepository = scrapRepository
  }
}

// MARK: - DestinationRecommendUseCase
extension DefaultDestinationRecommendUseCase: DestinationRecommendUseCase {
  func fetchDestinationList(page: Int?, perPage: Int?) -> AnyPublisher<[DestinationRecommendSection], any Error> {
    return recommendRepository.fetchRecommendationDestinationList(page: page, perPage: perPage)
  }
  
  func toggleDestinationScrap(id: Int, folderName: String?)  -> AnyPublisher<DestinationScrapToggler, any Error> {
    return scrapRepository.toggleDestinationScrap(id: id, folderName: folderName)
  }
}
