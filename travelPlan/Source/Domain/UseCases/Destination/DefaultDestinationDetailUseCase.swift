//
//  DefaultDestinationDetailUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/31/24.
//

import Foundation
import Combine

final class DefaultDestinationDetailUseCase {
  // MARK: - Dependencies
  private let likeRepository: any DestinationLikeRepository
  private let scrapRepository: any DestinationScrapRepository
  private let destinationRepository: any DestinationRepository
  
  init(
    likeRepository: any DestinationLikeRepository,
    scrapRepository: any DestinationScrapRepository,
    destinationRepository: any DestinationRepository
  ) {
    self.likeRepository = likeRepository
    self.scrapRepository = scrapRepository
    self.destinationRepository = destinationRepository
  }
}

extension DefaultDestinationDetailUseCase: DestinationDetailUseCase {
  func fetchDetail(
    destinationId: DestinationIdEntity
  ) -> AnyPublisher<DestinationEntity, any Error> {
    return destinationRepository.fetchDestination(destinationId: destinationId)
  }
  
  func toggleScrap(id: Int, folderName: String?) -> AnyPublisher<DestinationScrapToggler, any Error> {
    return scrapRepository.toggleDestinationScrap(id: id, folderName: folderName)
  }
  
  func toggleLike(id: Int) -> AnyPublisher<DestinationLike, any Error> {
    return likeRepository.toggleDestinationLike(destinationId: id)
  }
}

