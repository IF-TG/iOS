//
//  DefaultDestinationSearchResultUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/15/24.
//

import Foundation
import Combine

final class DefaultDestinationSearchResultUseCase {
  // MARK: - Dependencies
  private let searchRepository: DestinationSearchRepository
  private let scrapRepository: DestinationScrapRepository
  
  // MARK: - LifeCycle
  init(
    destinationSearchRepository: DestinationSearchRepository,
    destinationScrapRepository: DestinationScrapRepository
  ) {
    self.searchRepository = destinationSearchRepository
    self.scrapRepository = destinationScrapRepository
  }
}

extension DefaultDestinationSearchResultUseCase: DestinationSearchResultUseCase {
  func fetchDestinationList(
    keyword: String,
    page: Int32?,
    perPage: Int32?
  ) -> AnyPublisher<[ThumbnailDestination], any Error> {
    return searchRepository.fetchDestinationList(by: keyword, page: page, perPage: perPage)
  }
  
  func toggleScrap(
    id: Int64,
    folderName: String?
  ) -> AnyPublisher<DestinationScrapToggler, any Error> {
    return scrapRepository.toggleDestinationScrap(id: id, folderName: folderName)
  }
}
